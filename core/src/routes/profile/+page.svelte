<!-- src/routes/profile/+page.svelte -->
<script lang="ts">
    import { 
        MagnifyingGlass, FunnelSimple,
        User, EnvelopeSimple, Phone, 
        Calendar, GraduationCap, Clock, 
        BookOpen, CaretRight, FileText, 
        Books, Star, Gear,
        Blueprint,
        Buildings, Bell
    } from 'phosphor-svelte';
    
    import { profileStore } from '$lib/stores/profile.svelte';

    let quickLinks = $derived(profileStore.getQuickLinks());
    // Get data from store using derived values
    let profile = $derived(profileStore.profile);
    let academic = $derived(profileStore.academicInfo);
    let courses = $derived(profileStore.currentCourses);
    let activities = $derived(profileStore.recentActivities);
    let library = $derived(profileStore.libraryItems);
    let deadlines = $derived(profileStore.upcomingDeadlines);
    let avatarUrl = $derived(profileStore.avatarUrl);
    let fullProgress = $derived(profileStore.fullProgress);
</script>

<div class="min-h-screen bg-base-100">
    <!-- Profile Header -->
    <div class="bg-gradient-to-br from-primary/10 via-base-100 to-base-200 py-12">
        <div class="container mx-auto px-4">
            <!-- Avatar and Basic Info -->
            <div class="flex flex-col md:flex-row gap-8 items-start">
                <div class="flex flex-col items-center md:items-start gap-6">
                    <div class="avatar online">
                        <div class="w-32 rounded-full ring ring-primary ring-offset-base-100 ring-offset-2">
                            <img src={avatarUrl} alt={profile.full_name} />
                        </div>
                    </div>
                    <div class="text-center md:text-left space-y-2">
                        <h1 class="text-3xl font-bold">{profile.full_name}</h1>
                        <div class="flex items-center gap-2 text-primary font-semibold">
                            <GraduationCap weight="duotone" class="w-5 h-5" />
                            {academic.program}
                        </div>
                        <div class="badge badge-primary">{profile.status}</div>
                    </div>
                </div>

                <!-- Academic Stats -->
                <div class="flex-1 grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="stat bg-base-100 shadow-lg rounded-box">
                        <div class="stat-figure text-primary">
                            <Star weight="duotone" size={32} />
                        </div>
                        <div class="stat-title">GPA</div>
                        <div class="stat-value text-primary">{academic.gpa}</div>
                        <div class="stat-desc">Current Standing</div>
                    </div>
                    
                    <div class="stat bg-base-100 shadow-lg rounded-box">
                        <div class="stat-figure text-secondary">
                            <Books weight="duotone" size={32} />
                        </div>
                        <div class="stat-title">Credits</div>
                        <div class="stat-value text-secondary">
                            {academic.creditsCompleted}
                            <span class="text-lg">/{academic.creditsRequired}</span>
                        </div>
                        <div class="stat-desc">Completed</div>
                    </div>
                    
                    <div class="stat bg-base-100 shadow-lg rounded-box">
                        <div class="stat-figure text-accent">
                            <Calendar weight="duotone" size={32} />
                        </div>
                        <div class="stat-title">Semester</div>
                        <div class="stat-value">{academic.semester}</div>
                        <div class="stat-desc">Current</div>
                    </div>
                </div>
            </div>

            <!-- Progress Bar -->
            <div class="mt-8">
                <div class="flex justify-between text-sm mb-2">
                    <span>Progress</span>
                    <span>{academic.progress}%</span>
                </div>
                <div class="w-full bg-base-100 rounded-full h-4 shadow-inner">
                    <div class="bg-primary h-4 rounded-full transition-all duration-500"
                         style="width: {academic.progress}%">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mx-auto px-4 py-12">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Left Column -->
            <div class="space-y-8">
                <!-- Personal Information -->
                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <h2 class="card-title flex items-center gap-2">
                            <User weight="duotone" class="text-primary" />
                            Personal Information
                        </h2>
                        <div class="space-y-4">
                            <div class="flex items-center gap-3">
                                <EnvelopeSimple weight="duotone" class="text-primary" />
                                <span>{profile.email}</span>
                            </div>
                            <div class="flex items-center gap-3">
                                <Buildings weight="duotone" class="text-primary" />
                                <span>{academic.faculty}</span>
                            </div>
                            <div class="flex items-center gap-3">
                                <User weight="duotone" class="text-primary" />
                                <span>ID: {academic.studentId}</span>
                            </div>
                            <div class="flex items-center gap-3">
                                <Clock weight="duotone" class="text-primary" />
                                <span>Member since {new Date(profile.created_at).getFullYear()}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card bg-base-100 shadow-xl">
					<div class="card-body">
						<h2 class="card-title flex items-center gap-2">
							<Star weight="duotone" class="text-primary" />
							Quick Links
						</h2>
						<div class="space-y-2">
							{#each quickLinks as link}
								<a
									href={link.href}
									class="btn btn-ghost w-full justify-between text-left hover:bg-primary/10 group"
								>
									<span class="flex items-center gap-2">
										<link.icon class="w-5 h-5" />
										{link.text}
									</span>
									<CaretRight class="transition-transform group-hover:translate-x-1 w-5 h-5" />
								</a>
							{/each}
						</div>
					</div>
				</div>

            </div>

            <!-- Main Column -->
            <div class="lg:col-span-2 space-y-8">
                <!-- Current Courses -->
                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <h2 class="card-title flex items-center gap-2">
                            <BookOpen weight="duotone" class="text-primary" />
                            Current Courses
                        </h2>
                        <div class="overflow-x-auto">
                            <table class="table table-zebra">
                                <thead>
                                    <tr>
                                        <th>Code</th>
                                        <th>Course</th>
                                        <th>Schedule</th>
                                        <th>Grade</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {#each courses as course}
                                        <tr>
                                            <td>{course.code}</td>
                                            <td>
                                                <div>
                                                    <div class="font-bold">{course.name}</div>
                                                    <div class="text-sm opacity-50">{course.professor}</div>
                                                </div>
                                            </td>
                                            <td>
                                                <div>
                                                    <div>{course.schedule}</div>
                                                    <div class="text-sm opacity-50">{course.room}</div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="badge badge-primary">{course.grade}</div>
                                            </td>
                                        </tr>
                                    {/each}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Recent Activities -->
                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <h2 class="card-title flex items-center gap-2">
                            <!-- <Activity weight="duotone" class="text-primary" /> -->
                            Recent Activities
                        </h2>
                        <div class="space-y-4">
                            {#each activities as activity}
                                <div class="flex items-center justify-between p-4 bg-base-200 rounded-lg hover:bg-base-300 transition-colors">
                                    <div class="flex items-center gap-4">
                                        {#if activity.type === 'submission'}
                                            <FileText weight="duotone" class="text-primary" />
                                        {:else if activity.type === 'attendance'}
                                            <Calendar weight="duotone" class="text-secondary" />
                                        {:else}
                                            <Books weight="duotone" class="text-accent" />
                                        {/if}
                                        <div>
                                            <div class="font-semibold">{activity.action}</div>
                                            <div class="text-sm opacity-70">{activity.date}</div>
                                        </div>
                                    </div>
                                    <span class="badge badge-ghost">{activity.status}</span>
                                </div>
                            {/each}
                        </div>
                    </div>
                </div>

                <!-- Deadlines & Library Items Grid -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Upcoming Deadlines -->
                    <div class="card bg-base-100 shadow-xl">
                        <div class="card-body">
                            <h2 class="card-title flex items-center gap-2">
                                <Clock weight="duotone" class="text-primary" />
                                Deadlines
                            </h2>
                            <div class="space-y-4">
                                {#each deadlines as deadline}
                                    <div class="flex flex-col p-4 bg-base-200 rounded-lg hover:bg-base-300 transition-colors">
                                        <div class="font-semibold">{deadline.task}</div>
                                        <div class="text-sm opacity-70">{deadline.course}</div>
                                        <div class="mt-2">
                                            <span class="badge badge-primary">{deadline.dueDate}</span>
                                        </div>
                                    </div>
                                {/each}
                            </div>
                        </div>
                    </div>

                    <!-- Library Items -->
                    <div class="card bg-base-100 shadow-xl">
                        <div class="card-body">
                            <h2 class="card-title flex items-center gap-2">
                                <Books weight="duotone" class="text-primary" />
                                Library Items
                            </h2>
                            <div class="space-y-4">
                                {#each library as item}
                                    <div class="flex flex-col p-4 bg-base-200 rounded-lg hover:bg-base-300 transition-colors">
                                        <div class="font-semibold">{item.title}</div>
                                        <div class="text-sm flex justify-between items-center mt-2">
                                            <span class="opacity-70">Due: {item.dueDate}</span>
                                            <span class="badge badge-ghost">{item.status}</span>
                                        </div>
                                    </div>
                                {/each}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
