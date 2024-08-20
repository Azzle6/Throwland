using Items;
using Items.Throwable;
using Managers;
using TMPro;
using UnityEngine;

public class UIManager : Singleton<UIManager>
{
    public string SelectedBuilding;
    public GameObject DebugButtonsParent;
    public ThrowableItem_UI ButtonTemplate;

    public JaugeUI cityCd;
    public JaugeUI projectileCd;
    public TextMeshProUGUI projectileCountText;
    public CanvasGroup projectileUI;

    public Canvas GameOverCnv;
    public TextMeshProUGUI gameoverPlayerText;
    public Color[] colors;

    private void Start()
    {
        foreach (var itemsReference in GlobalManager.Instance.AssetsReferences.ThrowableReferences)
        {
            if (this.ButtonTemplate == null) break;
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

    public void DisplayDefeat(E_ItemOwner loser)
    {
        var winner = E_ItemOwner.PLAYER_1;
        if (loser == E_ItemOwner.PLAYER_1) winner = E_ItemOwner.PLAYER_2;

        gameoverPlayerText.text = winner.ToString();
        gameoverPlayerText.color = colors[(int)loser];
        GameOverCnv.enabled = true;
    }
}
