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
import net.minecraftforge.registries.IForgeRegistryEntry;

// Gameplay
import net.minecraft.util.ResourceLocation;

// Non Minecraft/Forge
import javax.annotation.Nullable;


/**
 * This class implements <code>IForgeRegistryEntry</code> and is an
 * own implementation of <code>ForgeRegistryEntry</code>. It's goal is
 * to reduce redundant code.
 */
public abstract class YoudirkNumericIORegistryEntry
  <T extends IForgeRegistryEntry<T>> implements IForgeRegistryEntry<T>
{
  private @Nullable ResourceLocation _REGISTRY_NAME = null;
  private final Class<T> _REGISTRY_TYPE;

  protected YoudirkNumericIORegistryEntry(Class<T> registryType)
  {
    this._REGISTRY_TYPE = registryType;
  }

  protected T setRegistryName(String path)
  {
    return this.setRegistryName(new ResourceLocation(Props.MODID, path));
  }

  @Override @SuppressWarnings("unchecked")
  public T setRegistryName(ResourceLocation name)
    throws IllegalStateException
  {
    if (this._REGISTRY_NAME != null) {
      throw new IllegalStateException(
        "A " +this._REGISTRY_TYPE.getSimpleName()+ " with the name '"
        +name.toString()+ "' does already exist!  setRegistryName()"
        + " called twice?");
    }

    String namespace = name.getNamespace();
    if (!namespace.equals(Props.MODID)) {
      Log.ger.warn(
        "Namespace of {} '{}' is '{}' and does not equals MODID '{}'!",
        this._REGISTRY_TYPE.getSimpleName(), name.toString(), namespace,
        Props.MODID);
    }

    this._REGISTRY_NAME = name;

    return (T) this;
  }

  @Override
  public @Nullable ResourceLocation getRegistryName()
  {
    return this._REGISTRY_NAME;
  }

  @Override
  public Class<T> getRegistryType()
  {
    return this._REGISTRY_TYPE;
  }
}
