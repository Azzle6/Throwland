using Unity.Netcode.Components;
using UnityEngine;

namespace Items.Buildings
{
    [RequireComponent(typeof(NetworkTransform))]
    public abstract class Building : Item
    {
        [SerializeField]
        private NetworkTransform networkTransform;

        public void Teleport(Vector3 pos)
        {
            this.networkTransform.Teleport(pos, Quaternion.identity, transform.localScale);
        }
        
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
        RESOURCE_SOURCE,
        REDIRECTOR
    }
}