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


/**
 * This class is the base for all own registries.  <code>T</code> must
 * be the base class of the registry entry.
 */
public abstract class YoudirkNumericIORegistry
  <T extends YoudirkNumericIORegistryEntry<T>>
{
  protected IForgeRegistry<T> fRegistry = null;

  protected YoudirkNumericIORegistry() {}

  protected void buildRegistry(RegistryBuilder<T> builder)
  {
    this.fRegistry = builder.create();
  }
}
