import Faculty from '../models/facultyModel.js';

export const addFaculty = async (req, res) => {
    try {
        console.log('Adding Faculty:', req.body);
        const faculty = new Faculty(req.body);
        await faculty.save();
        res.status(201).json(faculty);
    } catch (error) {
        console.error('Add Faculty Error:', error);
        res.status(400).json({ 
            message: error.message, 
            errors: error.errors 
        });
    }
};

export const getCourseFaculty = async (req, res) => {
    try {
        const faculty = await Faculty.find({ courseId: req.params.courseId }).populate('userId', 'firstName lastName email profilePhoto role department');
        res.status(200).json(faculty);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

export const deleteFaculty = async (req, res) => {
    try {
        await Faculty.findByIdAndDelete(req.params.id);
        res.status(200).json({ message: 'Faculty removed successfully' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
