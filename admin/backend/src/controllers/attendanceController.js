import { Attendance } from '../models/attendanceModel.js';
import { Student } from '../models/studentModel.js';
import moment from 'moment';

export const getAttendanceByDateAndFilters = async (req, res) => {
    try {
        const { date, department, course, subject, subjectCode } = req.query;
        
        // Use moment to start of day for comparison
        const queryDate = moment(date).startOf('day').toDate();
        const nextDay = moment(date).endOf('day').toDate();

        const attendance = await Attendance.find({
            date: { $gte: queryDate, $lte: nextDay },
            department,
            course,
            subject,
            subjectCode
        }).select('student studentId status isLate');
        
        res.status(200).json(attendance);
    } catch (error) {
        console.error("Error fetching attendance:", error);
        res.status(500).json({ message: 'Error fetching attendance', error: error.message });
    }
};

export const submitAttendanceBulk = async (req, res) => {
    try {
        const { date, attendanceList, department, course, subject, subjectCode } = req.body;
        const normalizedDate = moment(date).startOf('day').toDate();

        const operations = attendanceList.map((entry) => ({
            updateOne: {
                filter: { student: entry.student, date: normalizedDate, subject: subjectCode },
                update: { 
                    $set: { 
                        ...entry, 
                        date: normalizedDate,
                        department,
                        course,
                        subject,
                        subjectCode
                    } 
                },
                upsert: true
            }
        }));

        await Attendance.bulkWrite(operations);
        res.status(200).json({ message: 'Attendance updated successfully' });
    } catch (error) {
        console.error("Error bulk submitting attendance:", error);
        res.status(500).json({ message: 'Error bulk submitting attendance', error: error.message });
    }
};

// Summary for statistics tab
export const getAttendanceStats = async (req, res) => {
    try {
        const today = moment().startOf('day').toDate();
        const nextDay = moment().endOf('day').toDate();

        const present = await Attendance.countDocuments({ date: { $gte: today, $lte: nextDay }, status: 'Present' });
        const late = await Attendance.countDocuments({ date: { $gte: today, $lte: nextDay }, status: 'Late' });
        const totalToday = await Attendance.countDocuments({ date: { $gte: today, $lte: nextDay } });

        const studentsCount = await Student.countDocuments();

        res.status(200).json({
            presentToday: present + late,
            lateToday: late,
            totalStudents: studentsCount,
            absentToday: studentsCount - (present + late)
        });
    } catch (error) {
        res.status(500).json({ message: 'Error fetching stats', error: error.message });
    }
};
