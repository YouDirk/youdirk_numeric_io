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
import net.minecraftforge.registries.ForgeRegistryEntry;
import net.minecraftforge.registries.IForgeRegistryEntry;

// Gameplay
import net.minecraft.util.ResourceLocation;

// Non Minecraft/Forge
import javax.annotation.Nullable;


/**
 * This class is a work-around for the poor Java Generics type
 * checking.  Use this type for <code>NetMessageRegistry</code> stuff.
 */
public abstract class NetMessageBase
  implements IForgeRegistryEntry<NetMessageBase>
{
  private @Nullable ResourceLocation _REGISTRY_NAME = null;

  /**
   * <b>The HashCode of the <code>registryPath</code> is used as
   * NetworkID for your message!</b> For this reason, do not rename it
   * to hold the network protocol compatible.
   */
  protected NetMessageBase(String registryPath)
  {
    // Namespace must be set, otherwise we get a runtime warning O.O
    this.setRegistryName(registryPath);
  }

  public int getNetId()
  {
    return this._REGISTRY_NAME.getPath().hashCode();
  }

  /* *****************************************************************
   * Implementing interface IForgeRegistryEntry
   */

  private NetMessageBase setRegistryName(String path)
  {
    return this.setRegistryName(new ResourceLocation(Props.MODID, path));
  }
  public NetMessageBase setRegistryName(ResourceLocation name)
  {
    if (this._REGISTRY_NAME != null) {
      throw new IllegalStateException("A NetMessage with the name '"
        +name.toString()+ "' does already exist!  setRegistryName()"
        + " called twice?");
    }

    String namespace = name.getNamespace();
    if (!namespace.equals(Props.MODID)) {
      Log.ger.warn(
        "Namespace of NetMessage '{}' is '{}' and does not equals MODID"
        + " '{}'!", name.toString(), namespace, Props.MODID);
    }

    this._REGISTRY_NAME = name;

    return this;
  }

  public @Nullable ResourceLocation getRegistryName()
  {
    return this._REGISTRY_NAME;
  }

  public Class<NetMessageBase> getRegistryType()
  {
    return NetMessageBase.class;
  }

  /* *************************************************************  */
}
