// src/lib/stores/records.svelte.ts
import type { Subject } from '$lib/stores/schedule.svelte';
import { Calculator, Code, Atom } from 'phosphor-svelte';

export interface Semester {
    id: string;
    semester: string;
    year: number;
    gpa: number;
    subjects: Subject[];  // Changed from courses to subjects
}

const defaultSemesters: Semester[] = [
    {
        id: 'fall-2023',
        semester: 'Fall',
        year: 2023,
        gpa: 3.9,
        subjects: [
            {
                id: 'calc-1',
                name: 'Calculus I',
                day: 1,
                startHour: 9,
                duration: 2,
                color: 'hsl(217, 91%, 60%)',
                icon: Calculator,
                professor: 'Dr. Smith',
                room: 'M101'
            },
            {
                id: 'prog-intro',
                name: 'Introduction to Programming',
                day: 2,
                startHour: 11,
                duration: 2,
                color: 'hsl(142, 71%, 45%)',
                icon: Code,
                professor: 'Dr. Johnson',
                room: 'CS202'
            }
        ]
    },
    {
        id: 'spring-2023',
        semester: 'Spring',
        year: 2023,
        gpa: 3.8,
        subjects: [
            {
                id: 'phys-1',
                name: 'Physics I',
                day: 4,
                startHour: 10,
                duration: 2,
                color: 'hsl(4, 90%, 58%)',
                icon: Atom,
                professor: 'Dr. Brown',
                room: 'P303'
            }
        ]
    }
];

class AcademicRecordsStore {
    semesters = $state<Semester[]>(defaultSemesters);

    reset() {
        this.semesters = defaultSemesters;
    }
}

export const academicRecords = new AcademicRecordsStore();