// src/lib/stores/schedule.svelte.ts
import { 
    Calculator, Code, Book, Atom, ChalkboardTeacher 
} from 'phosphor-svelte';

export interface Subject {
    id: string;
    name: string;
    day: number;
    startHour: number;
    duration: number;
    color: string;
    icon: any; // PhosphorIcon type
    professor?: string;
    room?: string;
}

class ScheduleStore {
    // Core state using runes
    subjects = $state<Subject[]>([
        {
            id: 'calc-1',
            name: 'Calculus I',
            day: 1, // Monday
            startHour: 9,
            duration: 2,
            color: 'hsl(217, 91%, 60%)', // Blue
            icon: Calculator,
            professor: 'Dr. Smith',
            room: 'M101'
        },
        {
            id: 'prog-intro',
            name: 'Introduction to Programming',
            day: 2, // Tuesday
            startHour: 11,
            duration: 2,
            color: 'hsl(142, 71%, 45%)', // Green
            icon: Code,
            professor: 'Dr. Johnson',
            room: 'CS202'
        },
        {
            id: 'phys-1',
            name: 'Physics I',
            day: 4, // Thursday
            startHour: 10,
            duration: 2,
            color: 'hsl(4, 90%, 58%)', // Red
            icon: Atom,
            professor: 'Dr. Brown',
            room: 'P303'
        },
        {
            id: 'eng-comp',
            name: 'English Composition',
            day: 3, // Wednesday
            startHour: 14,
            duration: 2,
            color: 'hsl(35, 100%, 50%)', // Orange
            icon: Book,
            professor: 'Dr. Wilson',
            room: 'E101'
        },
        {
            id: 'data-struct',
            name: 'Data Structures',
            day: 5, // Friday
            startHour: 13,
            duration: 2,
            color: 'hsl(259, 94%, 51%)', // Purple
            icon: ChalkboardTeacher,
            professor: 'Dr. Davis',
            room: 'CS303'
        }
    ]);

    // Week settings
    readonly days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    readonly hours = Array.from({ length: 9 }, (_, i) => i + 8); // 8 AM to 4 PM

    // Computed values using runes
    subjectsByDay = $derived(
        this.days.map((_, index) => 
            this.subjects.filter(subject => subject.day === index + 1)
        )
    );

    // Methods
    addSubject(subject: Subject) {
        this.subjects = [...this.subjects, subject];
    }

    removeSubject(id: string) {
        this.subjects = this.subjects.filter(s => s.id !== id);
    }

    updateSubject(id: string, updates: Partial<Subject>) {
        this.subjects = this.subjects.map(subject => 
            subject.id === id ? { ...subject, ...updates } : subject
        );
    }

    getSubjectsForDay(day: number) {
        return this.subjects.filter(subject => subject.day === day);
    }

    getSubjectById(id: string) {
        return this.subjects.find(subject => subject.id === id);
    }
}

export const scheduleStore = new ScheduleStore();