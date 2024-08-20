using System.Threading.Tasks;
using Items;
using Managers;
using TMPro;
using Unity.Netcode;
using Unity.Netcode.Transports.UTP;
using Unity.Networking.Transport.Relay;
using Unity.Services.Authentication;
using Unity.Services.Core;
using Unity.Services.Relay;
using Unity.Services.Relay.Models;

namespace Netcode
{
    using System;
    using System.Collections.Generic;
    using UnityEngine;
    
    public class RelayLobbyManager : MonoBehaviour
    {
        [SerializeField] 
        private GameObject relayLobbyUI;
        
        [SerializeField]
        private TMP_Text joinCodeText;
        [SerializeField]
        private TMP_InputField codeInputField;

        public DropdownUI regionDropDown;

        public List<Region> regions = new List<Region>();
        public string SelectedRegion { get ; private set; }
        
        private async void Start()
        {
            await UnityServices.InitializeAsync();

            await AuthenticationService.Instance.SignInAnonymouslyAsync();

            regions = await RelayService.Instance.ListRegionsAsync();
            List<string> regionNames = new List<string>();
            foreach (var region in regions)
            {
                regionNames.Add(region.Id);
            }

            regionDropDown.dropdown.ClearOptions();
            regionDropDown.dropdown.AddOptions(regionNames);
            regionDropDown.dropdown.onValueChanged.AddListener(OnRegionSelected);
        }

        private void OnRegionSelected(int index)
        {
            Debug.Log(index);
            SelectedRegion = regions[index].Id;
        }

        public async void StartRelayHost()
        {
            await this.TryDisconnect();
            GlobalManager.Instance.ClientTeam = E_ItemOwner.PLAYER_1;
            string joinCode = await this.StartHost();
            joinCodeText.text = joinCode;
            GUIUtility.systemCopyBuffer = joinCode;
            
        }

        public async void JoinRelay()
        {
            await this.TryDisconnect();
            GlobalManager.Instance.ClientTeam = E_ItemOwner.PLAYER_2;
            await this.StartClient(this.codeInputField.text);
            joinCodeText.text = this.codeInputField.text;
        }

        private async Task TryDisconnect()
        {
            if (NetworkManager.Singleton.IsConnectedClient)
            {
                NetworkManager.Singleton.Shutdown();
                await Task.Run(() =>
                {
                    try
                    {
                        while (NetworkManager.Singleton.ShutdownInProgress)
                        { }
                    }
                    catch
                    { }
                });
            }
        }

        private async Task<string> StartHost()
        {
            

            Allocation allocation = await RelayService.Instance.CreateAllocationAsync(2, SelectedRegion);
            
            NetworkManager.Singleton.GetComponent<UnityTransport>().SetRelayServerData(new RelayServerData(allocation, "dtls"));

            string joinCode = await RelayService.Instance.GetJoinCodeAsync(allocation.AllocationId);

            return NetworkManager.Singleton.StartHost() ? joinCode : null;
        }

        private async Task<bool> StartClient(string joinCode)
        {
            JoinAllocation joinAllocation = await RelayService.Instance.JoinAllocationAsync(joinCode);
            
            NetworkManager.Singleton.GetComponent<UnityTransport>().SetRelayServerData(new RelayServerData(joinAllocation, "dtls"));

            return !string.IsNullOrEmpty(joinCode) && NetworkManager.Singleton.StartClient();
        }
    }
}
