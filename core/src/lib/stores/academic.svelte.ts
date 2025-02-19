// src/lib/stores/academic.svelte.ts
import { 
    Buildings,
    Brain,
    Atom,
    Books,
    Globe,
    Users,
    GraduationCap,
    ChartLine,
    Palette,
    // Flash,
    Flask,
    Microscope,
    ChartDonut,
    Envelope

} from 'phosphor-svelte';

// Type for Phosphor icons
type IconType = typeof Buildings;

export interface AcademicProgram {
    id: string;
    name: string;
    code: string;
    description: string;
    duration: string;
    icon: IconType;
    details: string[];
    career_options?: string[];
    coordinator?: string;
    credits?: number;
}

export interface AcademicFeature {
    title: string;
    icon: IconType;
    description: string;
}

export interface SuccessStory {
    id: string;
    name: string;
    program: string;
    year: string;
    achievement: string;
    quote: string;
    image: string;
    position?: string;
    company?: string;
}

export interface AcademicStat {
    id: string;
    value: string;
    label: string;
    icon?: IconType;
    trend?: {
        direction: 'up' | 'down';
        value: string;
    };
}

class AcademicStore {
    // Academic programs
    programs = $state<AcademicProgram[]>([
        {
            id: 'eng-civil',
            name: 'Civil Engineering',
            code: 'ICI',
            description: 'Design and build the infrastructure of tomorrow',
            duration: '9 semesters',
            icon: Buildings,
            credits: 350,
            coordinator: 'Dr. Sarah Martinez',
            details: [
                'Infrastructure Development',
                'Structural Engineering',
                'Environmental Engineering',
                'Construction Management'
            ],
            career_options: [
                'Structural Engineer',
                'Project Manager',
                'Environmental Consultant',
                'Construction Supervisor'
            ]
        },
        {
            id: 'eng-comp',
            name: 'Computer Engineering',
            code: 'ICO',
            description: 'Shape the future of technology and computing',
            duration: '9 semesters',
            icon: Brain,
            credits: 352,
            coordinator: 'Dr. John Smith',
            details: [
                'Software Development',
                'Hardware Architecture',
                'Artificial Intelligence',
                'Network Systems'
            ],
            career_options: [
                'Software Engineer',
                'Systems Architect',
                'AI Developer',
                'Network Engineer'
            ]
        },
        {
            id: 'eng-mech',
            name: 'Mechanical Engineering',
            code: 'IME',
            description: 'Drive innovation in mechanical systems and manufacturing',
            duration: '9 semesters',
            icon: Atom,
            credits: 348,
            coordinator: 'Dr. Mark Johnson',
            details: [
                'Thermodynamics',
                'Robotics',
                'Manufacturing Systems',
                'Material Science'
            ],
            career_options: [
                'Mechanical Designer',
                'Robotics Engineer',
                'Manufacturing Engineer',
                'R&D Engineer'
            ]
        },
    {
              id: 'eng-elec',
              name: 'Electrical Engineering',
              code: 'IEE',
              description: 'Power the world with innovations in electrical systems',
              duration: '9 semesters',
              icon: Envelope,
              credits: 355,
              coordinator: 'Dr. Emily Davis',
              details: [
                'Power Systems',
                'Electronics',
                'Control Systems',
                'Telecommunications'
              ],
              career_options: [
                'Power Engineer',
                'Electronics Engineer',
                'Control Systems Engineer',
                'Telecommunications Engineer'
              ]
            },
            {
              id: 'eng-chem',
              name: 'Chemical Engineering',
              code: 'IQU',
              description: 'Transform materials and develop sustainable processes',
              duration: '9 semesters',
              icon: Flask,
              credits: 360,
              coordinator: 'Dr. Robert Brown',
              details: [
                'Process Engineering',
                'Biotechnology',
                'Materials Science',
                'Environmental Engineering'
              ],
              career_options: [
                'Process Engineer',
                'Biochemical Engineer',
                'Materials Engineer',
                'Environmental Consultant'
              ]
            },
            {
              id: 'bus-admin',
              name: 'Business Administration',
              code: 'ADE',
              description: 'Lead organizations and drive strategic growth',
              duration: '8 semesters',
              icon: ChartDonut,
              credits: 320,
              coordinator: 'Dr. Lisa Green',
              details: [
                'Management',
                'Finance',
                'Marketing',
                'Entrepreneurship'
              ],
              career_options: [
                'Business Analyst',
                'Financial Manager',
                'Marketing Director',
                'Entrepreneur'
              ]
            },
            {
              id: 'art-hist',
              name: 'History of Art',
              code: 'HAR',
              description: 'Explore the evolution of art and visual culture',
              duration: '8 semesters',
              icon: Palette,
              credits: 300,
              coordinator: 'Dr. Michael Angelo',
              details: [
                'Renaissance Art',
                'Modern Art',
                'Contemporary Art',
                'Art Theory'
              ],
              career_options: [
                'Art Historian',
                'Curator',
                'Art Critic',
                'Museum Educator'
              ]
            },
            {
              id: 'sci-bio',
              name: 'Biological Sciences',
              code: 'BIO',
              description: 'Uncover the mysteries of life and living organisms',
              duration: '8 semesters',
              icon: Microscope,
              credits: 330,
              coordinator: 'Dr. Jane Wilson',
              details: [
                'Molecular Biology',
                'Ecology',
                'Genetics',
                'Biochemistry'
              ],
              career_options: [
                'Research Scientist',
                'Biotechnologist',
                'Environmental Scientist',
                'Science Educator'
              ]
            }
    ]);

    // Key features
    features = $state<AcademicFeature[]>([
        {
            icon: GraduationCap,
            title: 'Research-Driven',
            description: 'Cutting-edge research opportunities and state-of-the-art facilities'
        },
        {
            icon: Globe,
            title: 'Global Perspective',
            description: 'International partnerships and exchange programs'
        },
        {
            icon: Users,
            title: 'Expert Faculty',
            description: 'Learn from industry leaders and renowned researchers'
        },
        {
            icon: ChartLine,
            title: 'Career Success',
            description: 'High employment rate and industry connections'
        }
    ]);

    // Academic statistics
    stats = $state<AcademicStat[]>([
        {
            id: 'employment',
            value: '95%',
            label: 'Employment Rate',
            icon: ChartLine,
            trend: {
                direction: 'up',
                value: '3%'
            }
        },
        {
            id: 'research',
            value: '200+',
            label: 'Research Papers',
            icon: Books,
            trend: {
                direction: 'up',
                value: '15%'
            }
        },
        {
            id: 'partners',
            value: '50+',
            label: 'Industry Partners',
            icon: Buildings
        },
        {
            id: 'international',
            value: '30+',
            label: 'International Partners',
            icon: Globe
        }
    ]);

    // Success stories
    successStories = $state<SuccessStory[]>([
        {
            id: 'story-1',
            name: 'Maria Rodriguez',
            program: 'Civil Engineering',
            year: '2023',
            achievement: 'National Engineering Competition Winner',
            quote: 'The hands-on experience and mentorship I received were invaluable for my career.',
            image: 'https://api.dicebear.com/9.x/adventurer/svg?seed=Maria',  // Using DiceBear for avatars
            position: 'Senior Project Engineer',
            company: 'Global Construction Corp'
        },
        {
            id: 'story-2',
            name: 'James Chen',
            program: 'Computer Engineering',
            year: '2023',
            achievement: 'Silicon Valley Startup Founder',
            quote: 'The entrepreneurial spirit and technical expertise I developed here shaped my success.',
            image: 'https://api.dicebear.com/9.x/adventurer/svg?seed=Mason',  // Using DiceBear for avatars
            position: 'CEO',
            company: 'TechVision AI'
        }
    ]);

    // Methods
    getProgramById(id: string): AcademicProgram | undefined {
        return this.programs.find(program => program.id === id);
    }

    getSuccessStoryById(id: string): SuccessStory | undefined {
        return this.successStories.find(story => story.id === id);
    }

    getProgramsByType(type: string): AcademicProgram[] {
        return this.programs.filter(program => program.code.startsWith(type));
    }

    // Search functionality
    searchPrograms(query: string): AcademicProgram[] {
        const searchTerm = query.toLowerCase();
        return this.programs.filter(program => 
            program.name.toLowerCase().includes(searchTerm) ||
            program.description.toLowerCase().includes(searchTerm) ||
            program.details.some(detail => detail.toLowerCase().includes(searchTerm))
        );
    }

    // Computed properties
    totalStudents = $derived(this.programs.length * 300);

    employmentRate = $derived(() => {
        const rate = this.stats.find(s => s.id === 'employment')?.value || '0%';
        return parseFloat(rate);
    });

    researchPapers = $derived(() => {
        const papers = this.stats.find(s => s.id === 'research')?.value || '0';
        return parseInt(papers.replace('+', ''));
    });
}

export const academicStore = new AcademicStore();

// src/lib/stores/academic-stats.ts
export interface AcademicStat {
    id: string;
    value: string;
    label: string;
}

class AcademicStatsStore {
    stats = $state<AcademicStat[]>([
        { 
            id: 'programs',
            value: '25+', 
            label: 'Academic Programs',
        },
        { 
            id: 'students',
            value: '1000+', 
            label: 'Active Students',
        },
        { 
            id: 'faculty',
            value: '100+', 
            label: 'Faculty Members',
        },
        { 
            id: 'success',
            value: '98%', 
            label: 'Success Rate',
        }
    ]);

    // Computed statistics
    totalStudents = $derived(
        parseInt(this.stats.find(s => s.id === 'students')?.value || '0')
    );

    getStats = () => this.stats;
    
    updateStat = (id: string, newValue: string) => {
        const statIndex = this.stats.findIndex(s => s.id === id);
        if (statIndex !== -1) {
            this.stats[statIndex] = { ...this.stats[statIndex], value: newValue };
        }
    };
}

export const academicStatsStore = new AcademicStatsStore();