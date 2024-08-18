using System;
using UnityEngine;

namespace Netcode
{
    using Unity.Netcode;
    
    public class NetworkPlayer : NetworkBehaviour
    {
        public NetworkVariable<Vector3> spawnPos = new NetworkVariable<Vector3>();
        
        public override void OnNetworkSpawn()
        {
            if (IsOwner)
            {
                this.RequestSpawnPositionServerRpc();
            }
        }

        [ServerRpc]
        void RequestSpawnPositionServerRpc()
        {
            this.spawnPos.Value = Vector3.right * NetworkManager.ConnectedClientsList.Count;
        }

        private void Update()
        {
            this.transform.position = this.spawnPos.Value;
        }
    }
}
