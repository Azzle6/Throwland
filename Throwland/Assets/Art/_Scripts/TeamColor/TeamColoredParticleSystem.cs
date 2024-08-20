using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeamColoredParticleSystem : TeamColoredVisual
{
    public Color[] colors;
    protected override void OnSetTeam()
    {
        base.OnSetTeam();
        ParticleSystem ps = GetComponent<ParticleSystem>();
        var main = ps.main;
        main.startColor = colors[teamIndex];
    }
}
