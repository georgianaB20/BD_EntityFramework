using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;

namespace Cinerva.Data
{
    public class CinervaDbContext : DbContext
    {
        public DbSet<User> Users { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<City> Cities { get; set; }
        public DbSet<Country> Countries { get; set; }
        public DbSet<Property> Properties { get; set; }
        public DbSet<GeneralFeature> GeneralFeatures { get; set; }
        public DbSet<PropertyType> PropertyTypes { get; set; }
        public DbSet<Reservation> Reservations { get; set; }
        public DbSet<Room> Rooms { get; set; }
        public DbSet<RoomCategory> RoomCategories { get; set; }
        public DbSet<RoomReservation> RoomReservations { get; set; }
        public DbSet<RoomFeature> RoomFeatures { get; set; }
        public DbSet<Review> Reviews { get; set; }
        public DbSet<PropertyImage> PropertyImages { get; set; }
        public DbSet<RoomFacility> RoomFacilities { get; set; }
        public DbSet<PropertyFacility> PropertyFacilities { get; set; }



        public CinervaDbContext() { }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer(@"Data Source=Laptop-51;Initial Catalog=Cinerva;Integrated Security=True")
                .LogTo(Console.WriteLine, LogLevel.Information);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Property>()
                .HasMany(p => p.GeneralFeatures)
                .WithMany(g => g.Properties)
                .UsingEntity<PropertyFacility>(
                    x => x.HasOne(pf => pf.Facility)
                    .WithMany(f => f.PropertyFacilities)
                    .HasForeignKey(pf => pf.FacilityId),
                    x => x.HasOne(pf => pf.Property)
                    .WithMany(p => p.PropertyFacilities)
                    .HasForeignKey(pf => pf.PropertyId),
                    x =>
                    {
                        x.HasKey(t => new { t.PropertyId, t.FacilityId });
                    });

            modelBuilder.Entity<Room>()
                .HasMany(p => p.RoomFeatures)
                .WithMany(g => g.Rooms)
                .UsingEntity<RoomFacility>(
                    x => x.HasOne(rf => rf.Facility)
                    .WithMany(f => f.RoomFacilities)
                    .HasForeignKey(rf => rf.FacilityId),
                    x => x.HasOne(rf => rf.Room)
                    .WithMany(r => r.RoomFacilities)
                    .HasForeignKey(rf => rf.RoomId),
                   x => { x.HasKey(f => new { f.RoomId, f.FacilityId }); }
                );

            modelBuilder.Entity<Review>()
                .HasKey(r => new { r.PropertyId, r.UserId });

            modelBuilder.Entity<Reservation>()
                .HasMany(re => re.Rooms)
                .WithMany(ro => ro.Reservations)
                .UsingEntity<RoomReservation>(
                x => x.HasOne(rr => rr.Room)
                .WithMany(re => re.RoomReservations)
                .HasForeignKey(r => r.RoomId),
                x => x.HasOne(r => r.Reservation)
                .WithMany(r => r.RoomReservations)
                .HasForeignKey(r => r.ReservationId),
                x => x.HasKey(k => k.Id)
            );

        }

    }
}
