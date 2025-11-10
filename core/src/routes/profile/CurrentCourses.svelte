<!-- src/routes/profile/+page.svelte -->
<script lang="ts">
	import { BookOpen, MapPin } from 'phosphor-svelte';
	import { scheduleStore } from '$lib/stores/schedule.svelte';

	// Get data from store using derived values
	let courses = $derived(scheduleStore.subjects);

	function formatTime(startHour: number, duration: number): string {
		const start = `${startHour.toString().padStart(2, '0')}:00`;
        const end = `${(startHour + duration).toString().padStart(2, '0')}:00`;
		return `${start} - ${end}`;
	}

</script>


<div class="card bg-base-100 shadow-xl">
    <div class="card-body p-6">
      <h2 class="card-title flex items-center gap-2 mb-6">
        <BookOpen weight="duotone" class="text-primary w-6 h-6" />
        Current Courses
      </h2>
      
      <div class="overflow-x-auto">
        <table class="table">
          <thead class="bg-base-200">
            <tr>
              <th class="rounded-l-lg">Code</th>
              <th>Course</th>
              <th>Schedule</th>
              <th class="rounded-r-lg">Professor</th>
            </tr>
          </thead>
          <tbody>
            {#each courses as course, index}
              <tr class="hover:bg-base-200 transition-colors">
                <td class="font-mono text-primary font-medium">{course.id}</td>
                <td>
                  <div class="flex items-center gap-2">
                    <course.icon weight="duotone" class="w-5 h-5" style="color: {course.color}" />
                    <div>
                      <div class="font-bold text-base">{course.name}</div>
                      <div class="badge badge-ghost badge-sm mt-1">Day {course.day}</div>
                    </div>
                  </div>
                </td>
                <td>
                  <div class="flex flex-col">
                    <span class="font-medium">
                      {formatTime(course.startHour, course.duration)}
                    </span>
                    {#if course.room}
                      <span class="text-sm opacity-70 flex items-center gap-1 mt-1">
                        <MapPin class="w-3 h-3" />
                        {course.room}
                      </span>
                    {/if}
                  </div>
                </td>
                <td>
                  {#if course.professor}
                    <div class="flex items-center gap-3">
                      <div class="flex flex-col">
                        <span class="font-medium">{course.professor}</span>
                        <span class="text-xs opacity-70">Professor</span>
                      </div>
                    </div>
                  {:else}
                    <span class="opacity-70">TBD</span>
                  {/if}
                </td>
              </tr>
              {#if index !== courses.length - 1}
                <tr>
                  <td colspan="4" class="p-0">
                    <div class="divider m-0"></div>
                  </td>
                </tr>
              {/if}
            {/each}
          </tbody>
        </table>
      </div>
    </div>
</div>