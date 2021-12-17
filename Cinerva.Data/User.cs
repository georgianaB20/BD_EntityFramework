﻿using System.Collections.Generic;

namespace Cinerva.Data
{
    public class User
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string? Phone { get; set; }
        public bool? IsDeleted { get; set; }
        public bool? IsBanned { get; set; }
        public int RoleId { get; set; }
        public Role Role { get; set; }
        public IList<Property> Properties { get; set; }
        public IList<Reservation> Reservations { get; set; }
        public IList<Review> Reviews { get; set; }


    }
}
