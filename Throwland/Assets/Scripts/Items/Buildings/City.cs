using Managers;
using UnityEngine;

namespace Items.Buildings
{
    public class City : Building
    {
        public override E_BuildingType BuildingType => E_BuildingType.CITY;
        [SerializeField]
        private CityVisuals cityVisuals;
        [SerializeField]
        private SpriteRenderer circleZoneRenderer;
        [SerializeField] 
        private TeamColoredSprite teamColor;

        public int TickCountBetweenGrowth = 5;
        
        private int tickGrowthCount;

        public override void OnNetworkSpawn()
        {
            
            this.HP.OnValueChanged += OnHPChanged;
            this.Owner.OnValueChanged += OnOwnerChanged;
            
            if(!IsHost)
                return;
            
            ChangeHpServerRpc(10);
            GlobalManager.Instance.Tick += this.TryGrowth;
        }

        private void OnOwnerChanged(E_ItemOwner previousvalue, E_ItemOwner newvalue)
        {
            Debug.Log($"Change city owner to {newvalue}.");
            this.cityVisuals.SetTeamIndex((int)Owner.Value);
            this.teamColor.SetTeam((int)this.Owner.Value);
        }

        private void OnHPChanged(int previousvalue, int newvalue)
        {
            Debug.Log($"Change city Hp from {previousvalue} to {newvalue}");
            if (newvalue <= 0)
            {
                GlobalManager.Instance.Tick -= this.TryGrowth;
                this.DeleteItemServerRpc();
                return;
            }
            this.circleZoneRenderer.size = Vector2.one * (newvalue / 5f);
            this.cityVisuals.UpdateRadius(newvalue / 10f, newvalue < previousvalue);
        }

        private void TryGrowth()
        {
            this.tickGrowthCount++;

            if (this.tickGrowthCount >= this.TickCountBetweenGrowth)
            {
                this.ChangeHpServerRpc(this.HP.Value + 1);
                this.tickGrowthCount = 0;
            }
        }
    }
}