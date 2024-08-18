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
            SetTeamServerRpc(Owner);
            
            if(!IsHost)
                return;
            
            GlobalManager.Instance.Tick += this.TryGrowth;
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

        [ServerRpc(RequireOwnership = false)]
        private void SetTeamServerRpc(E_ItemOwner owner)
        {
            this.cityVisuals.SetTeamIndex((int)owner);
        }
    }
}