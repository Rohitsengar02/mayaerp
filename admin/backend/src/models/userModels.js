import mongoose from 'mongoose';
import bcrypt from 'bcryptjs';

const userSchema = new mongoose.Schema({
    firstName: { type: String, default: 'Maya' },
    lastName: { type: String, default: 'User' },
    dob: { type: String },
    phone: { type: String },
    address: { type: String },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    role: { 
        type: String, 
        required: true, 
        enum: ['Admin', 'Staff', 'Faculty', 'Accountant', 'Librarian', 'HOD', 'Principal', 'Office'] 
    },
    department: { type: String },
    employeeId: { type: String },
    status: { type: String, default: 'Active' },
    profilePhoto: { type: String },
    createdAt: { type: Date, default: Date.now }
}, { discriminatorKey: 'role' });

// Virtual for backward compatibility
userSchema.virtual('name')
    .get(function() { return `${this.firstName} ${this.lastName}`; })
    .set(function(v) {
        const parts = v.split(' ');
        this.firstName = parts[0];
        this.lastName = parts.length > 1 ? parts.slice(1).join(' ') : '';
    });

// Ensure virtuals are serialized
userSchema.set('toJSON', { virtuals: true });
userSchema.set('toObject', { virtuals: true });

// Hash password before saving
userSchema.pre('save', async function () {
    if (!this.isModified('password')) return;
    this.password = await bcrypt.hash(this.password, 10);
});

export const User = mongoose.model('User', userSchema);

// Create discriminators for the seed script
export const Admin = User.discriminator('Admin', new mongoose.Schema({}));
export const OfficeStaff = User.discriminator('Office', new mongoose.Schema({}));
export const Staff = User.discriminator('Staff', new mongoose.Schema({}));
export const Librarian = User.discriminator('Library', new mongoose.Schema({}));
