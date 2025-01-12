// src/lib/stores/about.svelte.ts
import {
    Books,
    GraduationCap,
    Users,
    Buildings,
    Atom,
    Robot,
    Cpu
} from 'phosphor-svelte';

export interface Faculty {
    id: string;
    name: string;
    description: string;
    icon: any;
    stats: {
        programs: number;
        students: number;
        faculty: number;
    };
    featuredPrograms: string[];
}

export interface Milestone {
    year: string;
    title: string;
    description: string;
}

export interface Activity {
    id: string;
    type: 'academic' | 'research' | 'event' | 'achievement';
    title: string;
    date: string;
    description: string;
    image?: string;
    link?: string;
    category: string;
}

export interface CampusHighlight {
    id: string;
    title: string;
    description: string;
    image: string;
    stats?: {
        label: string;
        value: string;
    }[];
}

class AboutStore {
    // Core mission and values
    mission = $state("Empowering future leaders through innovative education and cutting-edge research");
    vision = $state("To be a global leader in academic excellence and technological innovation");

    // Quick stats
    quickStats = $state([
        { icon: GraduationCap, value: "15,000+", label: "Students" },
        { icon: Users, value: "1,000+", label: "Faculty Members" },
        { icon: Buildings, value: "6", label: "Campuses" },
        { icon: Books, value: "200+", label: "Research Publications" }
    ]);

    // Faculties
    faculties = $state<Faculty[]>([
        {
            id: "engineering",
            name: "Faculty of Engineering",
            description: "Leading innovation in engineering education and research",
            icon: Cpu,
            stats: {
                programs: 12,
                students: 5000,
                faculty: 200
            },
            featuredPrograms: [
                "Computer Engineering",
                "Mechanical Engineering",
                "Civil Engineering"
            ]
        },
        {
            id: "science",
            name: "Faculty of Science",
            description: "Advancing scientific knowledge and discovery",
            icon: Atom,
            stats: {
                programs: 8,
                students: 3000,
                faculty: 150
            },
            featuredPrograms: [
                "Physics",
                "Chemistry",
                "Mathematics"
            ]
        },
        {
            id: "technology",
            name: "Faculty of Technology",
            description: "Shaping the future of digital innovation",
            icon: Robot,
            stats: {
                programs: 10,
                students: 4000,
                faculty: 180
            },
            featuredPrograms: [
                "Computer Science",
                "Information Technology",
                "Data Science"
            ]
        }
    ]);

    // Historical milestones
    milestones = $state<Milestone[]>([
        {
            year: "1965",
            title: "Foundation",
            description: "Establishment of the main campus"
        },
        {
            year: "1985",
            title: "Research Excellence",
            description: "Opening of advanced research centers"
        },
        {
            year: "2000",
            title: "Global Expansion",
            description: "Launch of international programs"
        },
        {
            year: "2015",
            title: "Innovation Hub",
            description: "Creation of technology innovation center"
        },
        {
            year: "2024",
            title: "Digital Transformation",
            description: "Implementation of smart campus initiative"
        }
    ]);

    // Recent activities
    recentActivities = $state<Activity[]>([
        {
            id: "act-1",
            type: "research",
            title: "Breakthrough in Quantum Computing",
            date: "2024-03-10",
            description: "Research team achieves quantum supremacy milestone",
            image: "/api/placeholder/400/300",
            category: "Research"
        },
        {
            id: "act-2",
            type: "event",
            title: "International Technology Summit",
            date: "2024-03-15",
            description: "Annual gathering of global tech leaders",
            image: "/api/placeholder/400/300",
            category: "Events"
        },
        {
            id: "act-3",
            type: "achievement",
            title: "Top 50 Global University Ranking",
            date: "2024-03-20",
            description: "Recognition for academic excellence",
            image: "/api/placeholder/400/300",
            category: "Achievements"
        },
        {
            id: "act-4",
            type: "academic",
            title: "Launch of AI Ethics Program",
            date: "2024-03-25",
            description: "New curriculum addressing emerging technologies",
            image: "/api/placeholder/400/300",
            category: "Academic"
        }
    ]);

    // Campus highlights
    campusHighlights = $state<CampusHighlight[]>([
        {
            id: "highlight-1",
            title: "State-of-the-art Research Labs",
            description: "Cutting-edge facilities for breakthrough research",
            image: "/api/placeholder/400/300",
            stats: [
                { label: "Labs", value: "50+" },
                { label: "Equipment Value", value: "$100M+" },
                { label: "Research Projects", value: "200+" }
            ]
        },
        {
            id: "highlight-2",
            title: "Modern Learning Spaces",
            description: "Technology-enabled collaborative learning environments",
            image: "/api/placeholder/400/300",
            stats: [
                { label: "Classrooms", value: "100+" },
                { label: "Study Spaces", value: "1,000+" },
                { label: "Digital Resources", value: "10,000+" }
            ]
        },
        {
            id: "highlight-3",
            title: "Innovation Hub",
            description: "Center for entrepreneurship and innovation",
            image: "/api/placeholder/400/300",
            stats: [
                { label: "Startups", value: "25+" },
                { label: "Patents", value: "75+" },
                { label: "Partners", value: "50+" }
            ]
        }
    ]);

    // Methods to get data
    getFaculties = () => this.faculties;
    getMilestones = () => this.milestones;
    getRecentActivities = () => this.recentActivities;
    getCampusHighlights = () => this.campusHighlights;

    // Computed values using runes
    totalStudents = $derived(
        this.faculties.reduce((sum, faculty) => sum + faculty.stats.students, 0)
    );

    totalFaculty = $derived(
        this.faculties.reduce((sum, faculty) => sum + faculty.stats.faculty, 0)
    );

    totalPrograms = $derived(
        this.faculties.reduce((sum, faculty) => sum + faculty.stats.programs, 0)
    );
}

export const aboutStore = new AboutStore();