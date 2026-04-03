import mongoose from 'mongoose';
import dotenv from 'dotenv';
import dns from 'dns';

dns.setServers(['8.8.8.8', '8.8.4.4']);

import bcrypt from 'bcryptjs';
import { Admin, OfficeStaff, Staff, Librarian } from './models/userModels.js';

dotenv.config();

const hashPassword = async (password) => {
    return await bcrypt.hash(password, 10);
};

const seedDatabase = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/maya_erp');
        console.log('Connected to MongoDB for seeding...');

        // Clear existing data
        await Admin.deleteMany({});
        await OfficeStaff.deleteMany({});
        await Staff.deleteMany({});
        await Librarian.deleteMany({});

        const plainPassword = 'Password@123';

        // Seed Admin
        await Admin.create({
            name: 'System Administrator',
            email: 'admin@mayaerp.com',
            password: plainPassword,
            role: 'Admin',
            department: 'Central Management'
        });

        // Seed Office
        await OfficeStaff.create({
            name: 'Office Head',
            email: 'office@mayaerp.com',
            password: plainPassword,
            role: 'Office',
            department: 'Administration'
        });

        // Seed Staff/Teachers
        await Staff.create({
            name: 'Senior Teacher',
            email: 'staff@mayaerp.com',
            password: plainPassword,
            role: 'Staff',
            department: 'Academic'
        });

        // Seed Library
        await Librarian.create({
            name: 'Chief Librarian',
            email: 'library@mayaerp.com',
            password: plainPassword,
            role: 'Library',
            department: 'Books & Resources'
        });

        console.log(`
    ✅ Database Seeded Successfully!
    
    CREDENTIALS (All use the same password for testing):
    ---------------------------------------------------
    Password: ${plainPassword}
    
    1. Admin:   admin@mayaerp.com
    2. Office:  office@mayaerp.com
    3. Staff:   staff@mayaerp.com
    4. Library: library@mayaerp.com
    ---------------------------------------------------
    `);

        process.exit();
    } catch (error) {
        console.error('Error seeding database:', error);
        process.exit(1);
    }
};

seedDatabase();
