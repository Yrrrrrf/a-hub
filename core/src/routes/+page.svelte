<!-- src/routes/+page.svelte -->
<script lang="ts">
  import { goto } from '$app/navigation';
  import { 
      GraduationCap, 
      Users, 
      Books,
      Student,
      Chalkboard,
      Buildings,
      EnvelopeSimple,
      Phone
  } from 'phosphor-svelte';
  
  import { infrastructureStore } from '$lib/stores/infrastructure.svelte';
  import { academicStatsStore } from '$lib/stores/academic-stats.svelte';

  // Academic features showcase using runes
  let academicFeatures = $state([
      { 
          icon: Books, 
          title: 'Academic Excellence', 
          description: 'Comprehensive academic programs designed for success' 
      },
      { 
          icon: Student, 
          title: 'Student Success', 
          description: 'Supporting student achievement through innovative resources' 
      },
      { 
          icon: Chalkboard, 
          title: 'Modern Learning', 
          description: 'State-of-the-art facilities and teaching methodologies' 
      }
  ]);

  // Core modules with runes
  let coreModules = $state([
      { 
          title: 'Academic Programs', 
          description: 'Diverse range of undergraduate and graduate programs',
          icon: GraduationCap
      },
      { 
          title: 'Research Centers', 
          description: 'Advanced research facilities and opportunities',
          icon: Books
      },
      { 
          title: 'Student Services', 
          description: 'Comprehensive support for student success',
          icon: Users
      },
      { 
          title: 'Campus Life', 
          description: 'Rich cultural and educational experiences',
          icon: Buildings
      }
  ]);

  // Get main campus information
  let mainCampus = $derived(infrastructureStore.getMainCampus);
  let stats = $derived(academicStatsStore.getStats());
</script>

<div class="min-h-screen bg-base-200">
  <!-- Hero Section -->
  <section class="hero min-h-[80vh] relative bg-gradient-to-br from-primary/10 to-base-200">
      <div class="hero-content text-center">
          <div class="max-w-4xl">
              <h1 class="text-6xl font-bold mb-4">Welcome to Academic Hub</h1>
              <h2 class="text-3xl font-bold text-primary mb-8">
                  Shaping Tomorrow's Leaders
              </h2>
              <p class="text-xl mb-8 max-w-2xl mx-auto">
                  Discover a world-class education experience that combines academic excellence,
                  innovative research, and a vibrant campus community.
              </p>
              <div class="flex gap-4 justify-center">
                  <button class="btn btn-primary btn-lg" 
                      onclick={() => goto('/academic')}>
                      <GraduationCap weight="bold" class="w-5 h-5 mr-2" />
                      Explore Programs
                  </button>
                  <button class="btn btn-outline btn-lg"
                      onclick={() => goto('/news')}>
                      Latest Updates
                  </button>
              </div>
          </div>
      </div>
  </section>

  <!-- Features Section -->
  <section class="py-20 container mx-auto px-4">
      <h2 class="text-4xl font-bold text-center mb-16">Why Choose Us</h2>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          {#each academicFeatures as feature}
              <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all duration-300">
                  <div class="card-body items-center text-center">
                      <svelte:component this={feature.icon} 
                          weight="duotone"
                          class="w-16 h-16 text-primary mb-6" />
                      <h3 class="card-title text-2xl mb-4">{feature.title}</h3>
                      <p class="text-base-content/80 text-lg">{feature.description}</p>
                  </div>
              </div>
          {/each}
      </div>
  </section>

  <!-- Statistics Section -->
  <section class="bg-primary text-primary-content py-20">
      <div class="container mx-auto px-4">
          <div class="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
              {#each stats as stat}
                  <div class="stat p-4 transform hover:scale-105 transition-transform">
                      <div class="stat-value text-5xl font-bold mb-4">
                          {stat.value}
                      </div>
                      <div class="stat-label text-xl opacity-90">
                          {stat.label}
                      </div>
                  </div>
              {/each}
          </div>
      </div>
  </section>

  <!-- Core Modules Section -->
  <section class="py-20 container mx-auto px-4 bg-base-100">
      <h2 class="text-4xl font-bold text-center mb-16">Academic Experience</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {#each coreModules as module}
              <div class="card bg-base-200 shadow-lg hover:shadow-xl transition-all">
                  <div class="card-body items-center text-center">
                      <svelte:component this={module.icon} 
                          weight="duotone"
                          class="w-12 h-12 text-primary mb-4" />
                      <h3 class="card-title text-xl mb-4">{module.title}</h3>
                      <p class="text-base-content/70">{module.description}</p>
                  </div>
              </div>
          {/each}
      </div>
  </section>

  <!-- Contact Section -->
  <section class="py-16 bg-base-200">
      <div class="container mx-auto px-4">
          <div class="card bg-base-100 shadow-xl max-w-2xl mx-auto">
              <div class="card-body">
                  <h2 class="card-title text-3xl mb-6 flex items-center gap-3">
                      <Buildings weight="duotone" class="w-8 h-8 text-primary" />
                      Main Campus
                  </h2>
                  <div class="space-y-4">
                      <p class="flex items-center gap-3">
                          <Buildings class="w-5 h-5 text-primary" />
                          {mainCampus.address}
                      </p>
                      <p class="flex items-center gap-3">
                          <Phone class="w-5 h-5 text-primary" />
                          {mainCampus.phone}
                      </p>
                      <p class="flex items-center gap-3">
                          <EnvelopeSimple class="w-5 h-5 text-primary" />
                          {mainCampus.email}
                      </p>
                  </div>
              </div>
          </div>
      </div>
  </section>
</div>