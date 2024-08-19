using Managers;
using Unity.Netcode;
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

        public int TickCountBetweenGrowth = 5;
        
        private int tickGrowthCount;

        public override void OnNetworkSpawn()
        {
            this.HP.OnValueChanged += OnHPChanged;
            this.Owner.OnValueChanged += OnOwnerChanged;
            
            if(!IsHost)
                return;
            
            GlobalManager.Instance.Tick += this.TryGrowth;
        }

        private void OnOwnerChanged(E_ItemOwner previousvalue, E_ItemOwner newvalue)
        {
            Debug.Log($"Change city owner to {newvalue}.");
            this.cityVisuals.SetTeamIndex((int)Owner.Value);
        }

        private void OnHPChanged(int previousvalue, int newvalue)
        {
            this.circleZoneRenderer.size = Vector2.one * (newvalue / 5f);
            this.cityVisuals.UpdateRadius(newvalue / 10f);
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