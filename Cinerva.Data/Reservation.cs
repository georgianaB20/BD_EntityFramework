using System;
using System.Collections.Generic;

namespace Cinerva.Data
{
    public class Reservation
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public DateTime CheckInDate { get; set; }
        public DateTime CheckOutDate { get; set; }
        public bool? PayedStatus { get; set; }
        public string PaymentMethod { get; set; }
        public Nullable<DateTime> CancelDate { get; set; }
        public decimal Price { get; set; }

        public IList<RoomReservation> RoomReservations { get; set; }
        public IList<Room> Rooms { get; set; }
        public User User { get; set; }
    }
}
