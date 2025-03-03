class CredentialStore {
    isVisible = $state(false);

    toggle() {
        this.isVisible = !this.isVisible;
        console.log('Credential visibility:', this.isVisible);
    }
}

export const credentialStore = new CredentialStore();


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



class PS {
    // Academic information
    academicInfo = $state<AcademicInfo>({
        program: "Computer Science",
        semester: 6,
        studentId: "2021CS123",
        faculty: "Engineering",
        gpa: 3.85,
        creditsCompleted: 66,
        creditsRequired: 120,
    });

    fullProgress = $derived(
        (this.academicInfo.creditsCompleted / this.academicInfo.creditsRequired) * 100
    );

    updateAcademicInfo(newInfo: Partial<AcademicInfo>) {
        this.academicInfo = { ...this.academicInfo, ...newInfo };
    }


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

    addActivity(activity: Activity) {
        this.recentActivities = [activity, ...this.recentActivities];
    }

    addDeadline(deadline: Deadline) {
        this.upcomingDeadlines = [...this.upcomingDeadlines, deadline];
    }
}

export const okl = new PS();




















// src/lib/stores/profile.store.ts
import { authStore, type UserProfile } from 'rune-lab';
import { getForge, apiStore } from 'rune-lab';
import { BaseClient, createCrudOperations } from 'ts-forge';


// Basic academic info type
interface AcademicInfo {
    program: string;
    faculty: string;
    studentId: string;
    semester: number;
    gpa: number;
    creditsCompleted: number;
    creditsRequired: number;
}

class ProfileStore {
    isLoading = $state(true);
    error = $state<string | null>(null);

    // Use the existing profile from authStore
    profile = $derived(authStore.profile);

    // Basic academic info (temporary)
    academicInfo = $state<AcademicInfo>({
        program: "Computer Engineering",
        faculty: "Engineering",
        studentId: "2021CS123",
        semester: 6,
        gpa: 3.85,
        creditsCompleted: 128,
        creditsRequired: 255
    });

    // Simple avatar URL derivation
    avatarUrl = $derived(
        this.profile ? 
        `https://api.dicebear.com/7.x/avataaars/svg?seed=${this.profile.username}` : 
        ''
    );

    async fetchProfile() {
        try {
        this.isLoading = true;
        this.error = null;

        const baseClient = new BaseClient(apiStore.getConfig().URL);
        const t_metadata = (await getForge()).getTable('account', 'profile');
        
        if (!t_metadata) {
            throw new Error('Profile table metadata not found');
        }

        const crudOps = createCrudOperations<UserProfile>(baseClient, t_metadata);
        
        const userId = authStore.getUserId();
        if (!userId) {throw new Error('No authenticated user');}

        const profile = await crudOps.findOne(userId);
        console.log('Fetched profile:', profile);

        if (profile) {
            authStore.setProfile({ ...profile, ...authStore.profile });
        }
        console.log('Profile:', authStore.profile);

        } catch (e) {this.error = e instanceof Error ? e.message : 'Failed to load profile';
        } finally {this.isLoading = false;}
    }
}

export const profileStore = new ProfileStore();
