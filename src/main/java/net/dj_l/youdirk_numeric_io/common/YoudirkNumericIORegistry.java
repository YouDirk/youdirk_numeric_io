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
import net.minecraftforge.event.RegistryEvent;

// Gameplay
import net.minecraft.util.ResourceLocation;

// Non Minecraft/Forge
import javax.annotation.Nullable;
import javax.annotation.Nonnull;
import java.util.Iterator;
import java.util.Set;
import java.util.Collection;
import java.util.Map;
import java.util.Map.Entry;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.TreeMap;


/**
 * This class is the base for all own registries.  <code>T</code> must
 * be the base class of the registry entry.
 */
public abstract class YoudirkNumericIORegistry
  <T extends YoudirkNumericIORegistryEntry<T>>
  implements IForgeRegistry<T>, Iterable<T>
{
  /**
   * Performance vs. Features
   */
  public enum IterationOrderEnum
  {
    NO_ORDER, INSERTION_ORDER, KEY_ORDER
  }

  private final Class<T> _REGISTRY_TYPE;
  private final ResourceLocation _REGISTRY_NAME;
  private final Map<ResourceLocation,T> _map;

  protected YoudirkNumericIORegistry(Class<T> registryType,
    ResourceLocation registryName, IterationOrderEnum order)
  {
    this._REGISTRY_TYPE = registryType;
    this._REGISTRY_NAME = registryName;

    switch (order) {
    case NO_ORDER:
      this._map = new HashMap<ResourceLocation,T>();
      break;
    case INSERTION_ORDER:
      this._map = new LinkedHashMap<ResourceLocation,T>();
      break;
    case KEY_ORDER:
      this._map = new TreeMap<ResourceLocation,T>();
      break;
    default:
      this._map = new HashMap<ResourceLocation,T>();
      break;
    }

    if (YoudirkNumericIOEvent.MOD_BUS.post(
        new RegistryEvent.Register<T>(this._REGISTRY_NAME, this))) {
      throw new YoudirkNumericIORegistryException(this,
        "RegistryEvent.Register event was CANCELLED!");
    }
  }

  /* *****************************************************************
   * Implementing interface IForgeRegistry
   */

  @Override
  public ResourceLocation getRegistryName()
  {
    return this._REGISTRY_NAME;
  }

  @Override
  public Class<T> getRegistrySuperType()
  {
    return this._REGISTRY_TYPE;
  }

  @Override
  public void register(T value)
  {
    ResourceLocation key = value.getRegistryName();
    if (key == null) {
      throw new YoudirkNumericIORegistryException(this,
        "Registry Name for entry '" +value.toString()+ "' not set!");
    }

    T oldVal = _map.putIfAbsent(key, value);
    if (oldVal != null) {
      throw new YoudirkNumericIORegistryException(this,
        "Entry with Registry Name '" +key+ "' does already exist!");
    }
  }

  @SuppressWarnings("unchecked")
  @Override
  public void registerAll(T... values)
  {
    for (T val: values) this.register(val);
  }

  @Override
  public boolean containsKey(ResourceLocation key)
  {
    return this._map.containsKey(key);
  }

  @Override
  public boolean containsValue(T value)
  {
    return this._map.containsValue(value);
  }

  @Override
  public boolean isEmpty()
  {
    return this._map.isEmpty();
  }

  @Override
  public @Nullable T getValue(ResourceLocation key)
  {
    return this._map.get(key);
  }

  @Override
  public @Nullable ResourceLocation getKey(T value)
  {
    for (T val: this) {
      if (val.equals(value)) return val.getRegistryName();
    }

    return null;
  }

  @Override
  public @Nullable ResourceLocation getDefaultKey()
  {
    return null;
  }

  @Override
  public Set<ResourceLocation> getKeys()
  {
    return this._map.keySet();
  }

  @Override
  public Collection<T> getValues()
  {
    return this._map.values();
  }

  @Override
  public Set<Entry<ResourceLocation, T>> getEntries()
  {
    return null;
  }

  @Override
  public <T> T getSlaveMap(ResourceLocation slaveMapName, Class<T> type)
  {
    return null;
  }

  /* *****************************************************************
   * Implementing interface Iterable
   */

  @Override
  public Iterator<T> iterator()
  {
    return _map.values().iterator();
  }

  /* *************************************************************  */
}
