using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TeamColoredImage : TeamColoredVisual
{
    public Color[] colors;
    protected override void OnSetTeam()
    {
        base.OnSetTeam();
        GetComponent<Image>().color = colors[teamIndex];
    }
}
