using Items.Throwable;
using Managers;
using UnityEngine;

public class UIManager : MonoBehaviour
{
    public string SelectedBuilding;
    public GameObject DebugButtonsParent;
    public ThrowableItem_UI ButtonTemplate;
    private void Start()
    {
        foreach (var itemsReference in GlobalManager.Instance.AssetsReferences.ThrowableReferences)
        {
            ThrowableItem_UI itemUI = Instantiate(this.ButtonTemplate, this.DebugButtonsParent.transform);
            string id = itemsReference.Key;
            itemUI.Button.onClick.AddListener(() => SetSelectedBuilding(id));
            itemUI.UpdateView(new ThrowableItemData(((Throwable)itemsReference.Value).sprite, itemsReference.Key));
            SelectedBuilding = id;
        }
        
        SetSelectedBuilding("ThrowableCity");
    }

    public void SetSelectedBuilding(string id)
    {
        this.SelectedBuilding = id;
    }
}
