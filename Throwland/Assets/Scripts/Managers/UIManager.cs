using Managers;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class UIManager : MonoBehaviour
{
    public string SelectedBuilding;
    public GameObject DebugButtonsParent;
    public Button ButtonTemplate;

    private void Start()
    {
        foreach (var itemsReference in GlobalManager.Instance.AssetsReferences.ItemsReferences)
        {
            Button button = Instantiate(this.ButtonTemplate, this.DebugButtonsParent.transform);
            string id = itemsReference.Key;
            button.GetComponentInChildren<TMP_Text>().text = id;
            button.onClick.AddListener(() => SetSelectedBuilding(id));
        }
    }

    public void SetSelectedBuilding(string id)
    {
        this.SelectedBuilding = id;
    }
}
