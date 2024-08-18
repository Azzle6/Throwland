using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeamColoredSprite : TeamColoredVisual
{
    public Color[] colors;
    SpriteRenderer spriteRenderer;

    public override void Awake()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
        base.Awake();
    }

    protected override void OnSetTeam()
    {
        base.OnSetTeam();
        if (spriteRenderer == null) return;
        spriteRenderer.color = colors[teamIndex];
    }
}
