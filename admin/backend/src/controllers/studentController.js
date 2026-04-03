import { Student } from '../models/studentModel.js';
import { Application } from '../models/applicationModel.js';
import Branch from '../models/branchModel.js';

export const createStudent = async (req, res) => {
    try {
        const studentData = req.body;

        // Auto-generate Admission Number
        if (studentData.selectedBranch && studentData.sessionYear) {
            const branch = await Branch.findById(studentData.selectedBranch);
            if (branch) {
                const yearPrefix = studentData.sessionYear.split('-')[0]; // e.g., 2024 from 2024-25
                let branchCode = branch.branchCode || branch.name;
                // Strip non-alphabetic
                branchCode = branchCode.replace(/[^A-Za-z]/g, '').toUpperCase();
                if (!branchCode) branchCode = "STU";

                // Clean DOB for ID (DD only)
                const dobParts = (studentData.dob || '').split('/');
                const dayPart = dobParts.length > 0 ? dobParts[0].padStart(2, '0') : '00';
                
                let baseId = `${yearPrefix}${branchCode}${dayPart}`;
                let finalId = baseId;
                let counter = 1;
                
                // Ensure uniqueness
                while (await Student.findOne({ $or: [{ admissionNumber: finalId }, { studentId: finalId }] })) {
                    finalId = `${baseId}${counter.toString().padStart(2, '0')}`;
                    counter++;
                }

                studentData.admissionNumber = finalId;
                studentData.studentId = finalId;
            }
        }

        // Ensure password (default to DOB if missing)
        if (!studentData.password) {
            studentData.password = studentData.dob;
        }

        // Merge Cloudinary URLs from middleware ONLY if files were actually uploaded
        if (req.documentUrls) {
            if (req.documentUrls.applicantPhoto) {
                studentData.applicantPhoto = req.documentUrls.applicantPhoto;
            }
            
            if (!studentData.documents) studentData.documents = {};
            
            if (req.documentUrls.marksheet10) studentData.documents.marksheet10 = req.documentUrls.marksheet10;
            if (req.documentUrls.marksheet12) studentData.documents.marksheet12 = req.documentUrls.marksheet12;
            if (req.documentUrls.transferCertificate) studentData.documents.transferCertificate = req.documentUrls.transferCertificate;
            if (req.documentUrls.aadharCard) studentData.documents.aadharCard = req.documentUrls.aadharCard;
            if (req.documentUrls.entranceScoreCard) studentData.documents.entranceScoreCard = req.documentUrls.entranceScoreCard;
        }

        const student = new Student(studentData);
        await student.save();

        // If this student was generated from an application, update the application status
        if (studentData.applicationId) {
            await Application.findByIdAndUpdate(studentData.applicationId, { status: 'Accepted' });
        }

        // Increment branch occupancy if selectedBranch exists
        if (studentData.selectedBranch) {
            try {
                await Branch.findByIdAndUpdate(studentData.selectedBranch, { $inc: { occupancy: 1 } });
            } catch (err) {
                console.error("Failed to update branch occupancy", err);
            }
        }

        res.status(201).json(student);
    } catch (error) {
        res.status(500).json({ message: 'Error creating student', error: error.message });
    }
};

export const getAllStudents = async (req, res) => {
    try {
        const students = await Student.find().sort({ createdAt: -1 });
        res.status(200).json(students);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching students', error: error.message });
    }
};

export const getStudentById = async (req, res) => {
    try {
        const student = await Student.findById(req.params.id);
        if (!student) {
            return res.status(404).json({ message: 'Student not found' });
        }
        res.status(200).json(student);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching student', error: error.message });
    }
};

export const getStudentByStudentId = async (req, res) => {
    try {
        const { studentId } = req.params;
        // Case-insensitive search using regex
        const student = await Student.findOne({ 
            studentId: { $regex: new RegExp(`^${studentId}$`, 'i') } 
        });
        if (!student) {
            return res.status(404).json({ message: 'Student not found' });
        }
        res.status(200).json(student);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching student', error: error.message });
    }
};

export const updateStudent = async (req, res) => {
    try {
        const updateData = req.body;
        const student = await Student.findById(req.params.id);
        
        if (!student) {
            return res.status(404).json({ message: 'Student not found' });
        }

        // Add Cloudinary URLs if any
        if (req.documentUrls) {
            if (req.documentUrls.applicantPhoto) updateData.applicantPhoto = req.documentUrls.applicantPhoto;
            
            if (!updateData.documents) updateData.documents = {};
            
            if (req.documentUrls.marksheet10) updateData.documents.marksheet10 = req.documentUrls.marksheet10;
            if (req.documentUrls.marksheet12) updateData.documents.marksheet12 = req.documentUrls.marksheet12;
            if (req.documentUrls.transferCertificate) updateData.documents.transferCertificate = req.documentUrls.transferCertificate;
            if (req.documentUrls.aadharCard) updateData.documents.aadharCard = req.documentUrls.aadharCard;
            if (req.documentUrls.entranceScoreCard) updateData.documents.entranceScoreCard = req.documentUrls.entranceScoreCard;
        }

        // If DOB or Branch changed, potentially refresh ID
        if ((updateData.dob && updateData.dob !== student.dob) || 
            (updateData.selectedBranch && updateData.selectedBranch !== student.selectedBranch)) {
            
            const branchId = updateData.selectedBranch || student.selectedBranch;
            const branch = await Branch.findById(branchId);
            const sessionYear = updateData.sessionYear || student.sessionYear;
            const dob = updateData.dob || student.dob;

            if (branch && sessionYear && dob) {
                const yearPrefix = sessionYear.split('-')[0];
                let branchCode = branch.branchCode || branch.name;
                branchCode = branchCode.replace(/[^A-Za-z]/g, '').toUpperCase();
                if (!branchCode) branchCode = "STU";

                const dobParts = dob.split('/');
                const dayPart = dobParts.length > 0 ? dobParts[0].padStart(2, '0') : '00';
                
                let baseId = `${yearPrefix}${branchCode}${dayPart}`;
                let finalId = baseId;
                let counter = 1;
                
                // Ensure uniqueness (don't flag our own ID)
                while (await Student.findOne({ 
                    _id: { $ne: req.params.id }, 
                    $or: [{ admissionNumber: finalId }, { studentId: finalId }] 
                })) {
                    finalId = `${baseId}${counter.toString().padStart(2, '0')}`;
                    counter++;
                }

                updateData.admissionNumber = finalId;
                updateData.studentId = finalId;
            }
        }

        // Default password to DOB if missing (for legacy records)
        if (!student.password && !updateData.password) {
            updateData.password = updateData.dob || student.dob;
        }

        // Apply updates (excluding immutable fields)
        delete updateData._id;
        delete updateData.id;

        Object.assign(student, updateData);
        await student.save();

        res.status(200).json(student);
    } catch (error) {
        console.error("Update Student Error:", error);
        res.status(500).json({ message: 'Error updating student', error: error.message });
    }
};

export const deleteStudent = async (req, res) => {
    try {
        const student = await Student.findByIdAndDelete(req.params.id);
        if (!student) {
            return res.status(404).json({ message: 'Student not found' });
        }
        res.status(200).json({ message: 'Student deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting student', error: error.message });
    }
};

export const getLibraryMembers = async (req, res) => {
    try {
        const members = await Student.aggregate([
            {
                $lookup: {
                    from: 'issuebooks',
                    let: { studentId: '$_id' },
                    pipeline: [
                        {
                            $match: {
                                $expr: {
                                    $and: [
                                        { $eq: ['$student', '$$studentId'] },
                                        { $eq: ['$isVerified', true] },
                                        { $in: ['$status', ['Active', 'Overdue']] }
                                    ]
                                }
                            }
                        }
                    ],
                    as: 'activeIssues'
                }
            },
            {
                $lookup: {
                    from: 'branches',
                    localField: 'selectedBranch',
                    foreignField: '_id',
                    as: 'branchInfo'
                }
            },
            {
                $project: {
                    studentId: 1,
                    admissionNumber: 1,
                    firstName: 1,
                    lastName: 1,
                    sessionYear: 1,
                    branch: { $arrayElemAt: ['$branchInfo.name', 0] },
                    issues: { $size: '$activeIssues' },
                    applicantPhoto: 1,
                    photo: { $literal: 'https://i.pravatar.cc/150?img=1' }
                }
            }
        ]);
        res.status(200).json(members);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching library members', error: error.message });
    }
};
