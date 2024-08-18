using UnityEngine;

namespace Items.Buildings
{
    public abstract class Building : Item
    {
        public abstract E_BuildingType BuildingType { get; }
        
        public void PlaceBuilding(Vector3 pos)
        { }

        public override void OnHit(int damages)
        {
            Debug.Log("Get hit");
        }
    }

    public enum E_BuildingType
    {
        CITY,
        SERVICE,
        OBSTACLE,
        RESOURCE_SOURCE
    }
}