import Timetable from '../models/timetableModel.js';

export const saveTimetable = async (req, res) => {
    try {
        const { courseId, branchId, semester, schedule } = req.body;
        
        // Update existing or create new
        const timetable = await Timetable.findOneAndUpdate(
            { courseId, branchId, semester },
            { schedule },
            { new: true, upsert: true }
        ).populate('schedule.slots.facultyUserId', 'firstName lastName');
        
        // Emit live update
        const io = req.app.get('io');
        if (io) {
            io.emit('timetable_updated', { courseId, branchId, semester, timetable });
        }
        
        res.status(200).json(timetable);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

export const getTimetable = async (req, res) => {
    try {
        const { courseId, branchId, semester } = req.query;
        const timetable = await Timetable.findOne({ courseId, branchId, semester })
            .populate('schedule.slots.facultyUserId', 'firstName lastName email profilePhoto');
            
        if (!timetable) return res.status(200).json({ schedule: [] });
        res.status(200).json(timetable);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
