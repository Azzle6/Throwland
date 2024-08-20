using Items.Buildings;

namespace Items.Throwable
{
    using UnityEngine;
    
    public class Projectile : Throwable
    {
        public int Damage;
        
        public override void OnEndThrowServer()
        {
            
        }

        public override void OnCollide(Collider2D col)
        {
            Slinger slinger = col.GetComponent<Slinger>();
            if (slinger != null && slinger.ItemOwner.Value != this.Owner.Value)
            {
                Debug.Log($"Stun {slinger.ItemOwner.Value} with a projectile from {this.Owner.Value}.");
                slinger.StunSlinger();
                this.DeleteItemServerRpc();
                return;
            }

            City building = col.GetComponent<City>();
            if (building != null && building.Owner.Value != this.Owner.Value)
            {
                Debug.Log($"hit {building.Owner.Value} with a projectile from {this.Owner.Value}.");
                building.ChangeHpServerRpc(building.HP.Value - this.Damage);
                this.DeleteItemServerRpc();
                return;
            }
        }
    }
}