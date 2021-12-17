namespace Cinerva.Data
{
    public class RoomReservation
    {
        public int Id { get; set; }
        public int RoomId { get; set; }
        public int ReservationId { get; set; }

        public Room Room { get; set; }
        public Reservation Reservation { get; set; }
    }
}
