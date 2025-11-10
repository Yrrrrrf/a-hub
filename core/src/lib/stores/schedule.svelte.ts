// src/lib/stores/schedule.svelte.ts
import { 
    Calculator, Code, Book, Atom, ChalkboardTeacher, 
    Terminal,
    Database,
    Network,
    WaveSine
} from 'phosphor-svelte';

// Updated Subject interface with pdfLink
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
    pdfLink?: string;  // New field for PDF links
}

// Updated ScheduleStore
class ScheduleStore {
    // Core state using runes
    subjects = $state<Subject[]>([
        {
            id: 'sistemas-analogicos',
            name: 'Sistemas Analógicos',
            day: 1, // Monday
            startHour: 9,
            duration: 2,
            color: 'hsl(217, 91%, 60%)', // Blue
            icon: WaveSine, // Using appropriate icon for analog systems
            professor: 'Dr. Martínez',
            room: 'LAB-201',
            pdfLink: 'https://fi.uaemex.mx/portal/docs/coordinaciones/ICO/planF19/Periodo_6/6to_PE_ICO_SISTEMAS_ANALOGICOS.pdf'
        },
        {
            id: 'protocolos-comunicacion',
            name: 'Protocolos de Comunicación de Datos',
            day: 2, // Tuesday
            startHour: 11,
            duration: 2,
            color: 'hsl(142, 71%, 45%)', // Green
            icon: Network,
            professor: 'Dr. García',
            room: 'RED-301',
            pdfLink: 'https://fi.uaemex.mx/portal/docs/coordinaciones/ICO/planF19/Periodo_6/6to_PE_ICO_PROTOCOLOS_DE_COMUNICACION_DE_DATOS.pdf'
        },
        {
            id: 'admin-recursos',
            name: 'Administración de Recursos Informáticos',
            day: 3, // Wednesday
            startHour: 14,
            duration: 2,
            color: 'hsl(35, 100%, 50%)', // Orange
            icon: Database,
            professor: 'Dra. Rodríguez',
            room: 'ADM-102',
            pdfLink: 'https://fi.uaemex.mx/portal/docs/coordinaciones/ICO/planF19/Periodo_6/6to_PE_ICO_ADMINISTRACION_DE_RECURSOS_INFORMATICOS.pdf'
        },
        {
            id: 'ingenieria-software',
            name: 'Ingeniería de Software II',
            day: 4, // Thursday
            startHour: 10,
            duration: 2,
            color: 'hsl(4, 90%, 58%)', // Red
            icon: Code,
            professor: 'Dr. López',
            room: 'SW-401',
            pdfLink: 'https://fi.uaemex.mx/portal/docs/coordinaciones/ICO/planF19/Periodo_6/6to_PE_ICO_INGENIERIA_DE_SOFTWARE_II.pdf'
        },
        {
            id: 'compiladores',
            name: 'Compiladores',
            day: 4, // Thursday
            startHour: 13,
            duration: 2,
            color: 'hsl(259, 94%, 51%)', // Purple
            icon: Terminal,
            professor: 'Dr. Sánchez',
            room: 'COMP-201',
            pdfLink: 'https://fi.uaemex.mx/portal/docs/coordinaciones/ICO/planF19/Periodo_6/6to_PE_ICO_COMPILADORES.pdf'
        },
        {
            id: 'procesamiento-imagenes',
            name: 'Procesamiento de Imágenes Digitales',
            day: 5, // Friday
            startHour: 11,
            duration: 2,
            color: 'hsl(280, 85%, 65%)', // Purple variant
            icon: ChalkboardTeacher,
            professor: 'Dra. Torres',
            room: 'IMG-301',
            pdfLink: 'https://fi.uaemex.mx/portal/docs/coordinaciones/ICO/planF19/Periodo_6/6to_PE_ICO_PROCESAMIENTO_DE_IMAGENES_DIGITALES.pdf'
        }
    ]);

    // Week settings
    // readonly days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
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
