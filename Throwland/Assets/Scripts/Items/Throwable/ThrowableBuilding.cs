using Items.Buildings;
using Managers;
using UnityEngine;

namespace Items.Throwable
{
    public class ThrowableBuilding : Throwable
    {
        public Building BuildingToPlace;
        
        public override void OnEndThrow()
        {
            GlobalManager.Instance.RequestSpawnBuildingServerRpc(this.BuildingToPlace.ID, transform.position, this.Owner);
        }

        public override void OnCollide(Collider2D collider)
        {
        }
    }
}