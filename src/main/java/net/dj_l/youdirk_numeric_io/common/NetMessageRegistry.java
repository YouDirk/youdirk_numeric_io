/* This file is part of the `youdirk_numeric_io` Minecraft mod
 * Copyright (C) 2019  Dirk "YouDirk" Lehmann
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */


package net.dj_l.youdirk_numeric_io.common;
import net.dj_l.youdirk_numeric_io.*;

// Registries/Events
import net.minecraftforge.registries.IForgeRegistry;
import net.minecraftforge.registries.RegistryBuilder;
import net.minecraftforge.registries.IForgeRegistryInternal;
import net.minecraftforge.registries.RegistryManager;

// Gameplay
import net.minecraft.util.ResourceLocation;

// Non Minecraft/Forge
import javax.annotation.Nullable;


/**
 * A place where all sub-classes of <code>NetMessage</code> are
 * collected for registering these during <code>Setup</code>.
 */
public class NetMessageRegistry
  extends YoudirkNumericIORegistry<NetMessageBase>
  implements IForgeRegistry.BakeCallback<NetMessageBase>
{
  private final ResourceLocation
  _REGISTRY_NAME = new ResourceLocation(Props.MODID, "net_messages");

  private boolean _alreadyRegistered = false;

  public NetMessageRegistry()
  {
    super();
    NetMessageRegistry._INSTANCE = this;

    this.buildRegistry(new RegistryBuilder<NetMessageBase>()
                       .setType(NetMessageBase.class)
                       .setName(_REGISTRY_NAME)
                       .add(this)
                       .disableSaving());
  }

  private static @Nullable NetMessageRegistry _INSTANCE = null;
  public static @Nullable NetMessageRegistry get()
  {
    return NetMessageRegistry._INSTANCE;
  }

  @Override
  public void onBake(IForgeRegistryInternal<NetMessageBase> owner,
                     RegistryManager stage)
  {
    /* Called 2 times:
     *   1. on game setup, 2. on joining game
     */
    if (this._alreadyRegistered) return;

    for (NetMessageBase msg: owner)
      Net.registerMessage((NetMessage) msg);

    this._alreadyRegistered = true;
  }
}
