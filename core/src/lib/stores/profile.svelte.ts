// src/lib/stores/profile.svelte.ts
export interface UserProfile {
    id: string;
    username: string;
    email: string;
    full_name: string;
    status: 'active' | 'inactive' | 'suspended';
    created_at: string;
    updated_at: string;
}

export interface UserPreferences {
    user_id: string;
    theme: string;
    language: string;
    notifications: {
        email: boolean;
        push: boolean;
    };
    settings: Record<string, any>;
    updated_at: string;
}

export interface UserRole {
    id: string;
    name: string;
    description: string;
    permissions: Record<string, any>;
    created_at: string;
}

export interface AcademicInfo {
    program: string;
    semester: number;
    studentId: string;
    faculty: string;
    gpa: number;
    creditsCompleted: number;
    creditsRequired: number;
    progress: number;
}

export interface Course {
    code: string;
    name: string;
    professor: string;
    schedule: string;
    room: string;
    grade?: string;
}

export interface Activity {
    type: 'submission' | 'attendance' | 'library';
    course: string;
    action: string;
    date: string;
    status: string;
}

export interface LibraryItem {
    title: string;
    dueDate: string;
    status: string;
}

export interface Deadline {
    course: string;
    task: string;
    dueDate: string;
}

class ProfileStore {
    // Basic profile information
    profile = $state<UserProfile>({
        id: crypto.randomUUID(),
        username: "alexander.t",
        email: "alexander.t@academichub.edu",
        full_name: "Alexander Thompson",
        status: "active",
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
    });

    // User preferences
    preferences = $state<UserPreferences>({
        user_id: this.profile.id,
        theme: "dracula",
        language: "en",
        notifications: {
            email: true,
            push: true
        },
        settings: {},
        updated_at: new Date().toISOString()
    });

    // Academic information
    academicInfo = $state<AcademicInfo>({
        program: "Computer Science",
        semester: 6,
        studentId: "2021CS123",
        faculty: "Engineering",
        gpa: 3.85,
        creditsCompleted: 90,
        creditsRequired: 120,
        progress: 75
    });

    // Current courses
    currentCourses = $state<Course[]>([
        {
            code: "CS301",
            name: "Database Systems",
            professor: "Dr. Sarah Wilson",
            schedule: "Mon/Wed 10:00-11:30",
            room: "Tech-201",
            grade: "A"
        },
        {
            code: "CS302",
            name: "Software Engineering",
            professor: "Dr. Michael Brown",
            schedule: "Tue/Thu 14:00-15:30",
            room: "Tech-305",
            grade: "A-"
        },
        {
            code: "CS303",
            name: "Computer Networks",
            professor: "Dr. James Lee",
            schedule: "Wed/Fri 13:00-14:30",
            room: "Tech-405",
            grade: "B+"
        }
    ]);

    // Recent activities
    recentActivities = $state<Activity[]>([
        {
            type: "submission",
            course: "CS301",
            action: "Submitted Assignment: Database Design",
            date: "2024-03-15",
            status: "Completed"
        },
        {
            type: "attendance",
            course: "CS302",
            action: "Attended Lecture: Software Testing",
            date: "2024-03-14",
            status: "Present"
        },
        {
            type: "library",
            course: "CS303",
            action: "Borrowed: Computer Networks (5th Ed.)",
            date: "2024-03-13",
            status: "Active"
        }
    ]);

    // Library items
    libraryItems = $state<LibraryItem[]>([
        {
            title: "Database Management Systems",
            dueDate: "2024-04-01",
            status: "Borrowed"
        },
        {
            title: "Software Engineering Principles",
            dueDate: "2024-03-25",
            status: "Due Soon"
        }
    ]);

    // Upcoming deadlines
    upcomingDeadlines = $state<Deadline[]>([
        {
            course: "CS301",
            task: "Database Project Submission",
            dueDate: "2024-03-20"
        },
        {
            course: "CS302",
            task: "Software Design Documentation",
            dueDate: "2024-03-22"
        }
    ]);

    // Computed properties
    avatarUrl = $derived(
        `https://api.dicebear.com/7.x/avataaars/svg?seed=${this.profile.username}`
    );

    fullProgress = $derived(
        (this.academicInfo.creditsCompleted / this.academicInfo.creditsRequired) * 100
    );

    // Methods
    updateProfile(newProfile: Partial<UserProfile>) {
        this.profile = { ...this.profile, ...newProfile, updated_at: new Date().toISOString() };
    }

    updatePreferences(newPreferences: Partial<UserPreferences>) {
        this.preferences = { 
            ...this.preferences, 
            ...newPreferences, 
            updated_at: new Date().toISOString() 
        };
    }

    updateAcademicInfo(newInfo: Partial<AcademicInfo>) {
        this.academicInfo = { ...this.academicInfo, ...newInfo };
    }

    addActivity(activity: Activity) {
        this.recentActivities = [activity, ...this.recentActivities];
    }

    addDeadline(deadline: Deadline) {
        this.upcomingDeadlines = [...this.upcomingDeadlines, deadline];
    }
}

export const profileStore = new ProfileStore();
