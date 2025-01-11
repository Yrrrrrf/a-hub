// src/lib/stores/records.svelte.ts
export interface Course {
    code: string;
    name: string;
    credits: number;
    grade: string;
}

export interface Semester {
    id: string;
    semester: string;
    year: number;
    gpa: number;
    courses: Course[];
}

const defaultSemesters = [
    {
        id: 'fall-2023',
        semester: 'Fall',
        year: 2023,
        gpa: 3.9,
        courses: [
            { code: 'CS101', name: 'Introduction to Programming', credits: 3, grade: 'A' },
            { code: 'MA101', name: 'Calculus I', credits: 4, grade: 'A-' }
        ]
    },
    {
        id: 'spring-2023',
        semester: 'Spring',
        year: 2023,
        gpa: 3.8,
        courses: [
            { code: 'CS102', name: 'Data Structures', credits: 3, grade: 'A-' },
            { code: 'MA102', name: 'Calculus II', credits: 4, grade: 'B+' }
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
