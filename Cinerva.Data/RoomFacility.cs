namespace Cinerva.Data
{
    public class RoomFacility
    {
        public int? RoomId { get; set; }
        public int? FacilityId { get; set; }
        public Room Room { get; set; }
        public RoomFeature Facility { get; set; }
    }
}
