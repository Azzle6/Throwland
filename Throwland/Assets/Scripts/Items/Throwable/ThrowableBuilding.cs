using Items.Buildings;
using Managers;
using UnityEngine;

namespace Items.Throwable
{
    public class ThrowableBuilding : Throwable
    {
        public Building BuildingToPlace;
        
        public override void OnEndThrowServer()
        {
            if(BuildingToPlace == null) return;
            Debug.Log("End throw " + gameObject.name);
            if(Physics2D.OverlapPoint(transform.position,terrainMask) == null) return;

            GlobalManager.Instance.RequestSpawnBuildingServerRpc(this.BuildingToPlace.ID, transform.position, this.Owner);
        }

        public override void OnCollide(Collider2D collider)
        {
        }
    }
}