import mongoose from 'mongoose';
import bcrypt from 'bcryptjs';

const studentSchema = new mongoose.Schema({
    enrollmentNumber: { type: String, unique: true, sparse: true },
    admissionNumber: { type: String, unique: true, sparse: true },
    studentId: { type: String, unique: true, sparse: true },
    password: { type: String, required: true },
    applicationId: { type: mongoose.Schema.Types.ObjectId, ref: 'Application' },
    
    // Personal Details
    applicantPhoto: { type: String },
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    dob: { type: String, required: true },
    gender: { type: String, enum: ['Male', 'Female', 'Other'], required: true },
    email: { type: String, required: true },
    mobile: { type: String, required: true },
    alternateMobile: { type: String },
    address: { type: String, required: true },
    city: { type: String, required: true },
    state: { type: String, required: true },
    pinCode: { type: String, required: true },

    // Academic Info
    highestQualification: { type: String, required: true },
    institutionName: { type: String, required: true },
    boardUniversity: { type: String, required: true },
    percentageCGPA: { type: String, required: true },
    yearOfPassing: { type: String, required: true },
    subjectMarks: {
        subject1: { type: String },
        subject2: { type: String },
        subject3: { type: String }
    },
    entranceScore: { type: String },

    // Program Selection
    selectedBranch: { type: String },
    selectedProgram: { type: String, required: true },
    sessionYear: { type: String, required: true },
    category: { type: String, required: true },
    statementOfPurpose: { type: String },

    // Documents (Cloudinary URLs)
    documents: {
        marksheet10: { type: String },
        marksheet12: { type: String },
        transferCertificate: { type: String },
        aadharCard: { type: String },
        entranceScoreCard: { type: String }
    },

    status: {
        type: String,
        default: 'Approved'
    },
    studentStatus: {
        type: String,
        enum: ['Active', 'Inactive', 'Graduated', 'Suspended'],
        default: 'Active'
    },
    createdAt: { type: Date, default: Date.now }
});

// Pre-save hook to hash password
studentSchema.pre('save', async function() {
    if (!this.isModified('password')) return;
    
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
});

// Method to compare password for login
studentSchema.methods.comparePassword = async function(candidatePassword) {
    return await bcrypt.compare(candidatePassword, this.password);
};

export const Student = mongoose.model('Student', studentSchema);
