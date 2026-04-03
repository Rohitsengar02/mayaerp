import express from 'express';
import {
    createStudent,
    getAllStudents,
    getStudentById,
    getStudentByStudentId,
    updateStudent,
    deleteStudent,
    getLibraryMembers
} from '../controllers/studentController.js';

const router = express.Router();

router.post('/', createStudent);
router.get('/', getAllStudents);
router.get('/library/members', getLibraryMembers);
router.get('/:id', getStudentById);
router.get('/roll/:studentId', getStudentByStudentId);
router.put('/:id', updateStudent);
router.delete('/:id', deleteStudent);

export default router;
