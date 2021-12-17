using System.Collections.Generic;

namespace Cinerva.Data
{
    public class RoomCategory
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int BedsCount { get; set; }
        public string? Description { get; set; }
        public decimal Price { get; set; }
        public IList<Room> Rooms { get; set; }
    }
}
