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

            GlobalManager.Instance.RequestSpawnBuildingServerRpc(this.BuildingToPlace.ID, transform.position, this.Owner.Value);
            if (SoundManager.instance != null) SoundManager.instance.PlaySoundOnce("BuildCity");
        }

        public override void OnCollide(Collider2D collider)
        {
            City city = collider.GetComponent<City>();
            if (this.BuildingToPlace.GetType() == typeof(City) && city != null && city.Owner.Value == this.Owner.Value)
            {
                city.ChangeHpServerRpc(city.HP.Value + 10);
                this.DeleteItemServerRpc();
                if (SoundManager.instance != null) SoundManager.instance.PlaySoundOnce("GrowCity");
                return;
            }
        }
    }
}