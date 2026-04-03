import express from 'express';
import { 
    getAttendanceByDateAndFilters, 
    submitAttendanceBulk, 
    getAttendanceStats 
} from '../controllers/attendanceController.js';

const router = express.Router();

router.get('/', getAttendanceByDateAndFilters);
router.post('/bulk', submitAttendanceBulk);
router.get('/stats', getAttendanceStats);

export default router;
