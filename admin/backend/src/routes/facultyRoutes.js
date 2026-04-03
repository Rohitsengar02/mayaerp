import express from 'express';
import { addFaculty, getCourseFaculty, deleteFaculty } from '../controllers/facultyController.js';

const router = express.Router();

router.post('/', addFaculty);
router.get('/:courseId', getCourseFaculty);
router.delete('/:id', deleteFaculty);

export default router;
