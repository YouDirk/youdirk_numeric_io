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

// Gameplay
import net.minecraft.util.ResourceLocation;


/**
 * This class is a work-around for the poor Java Generics type
 * checking.  Use this type for <code>NetMessageRegistry</code> stuff.
 */
public abstract class NetMessageBase
  extends ForgeRegistryEntry<NetMessageBase>
{
  /**
   * A default constructor must be implemented to instanciate dummy
   * objects.  It can be empty, but <code>super()</code> must be
   * called.
   */
  public NetMessageBase()
  {
    /* Namespace must be "minecraft", otherwise we get a runtime
     * warning O.O
     */
    this.setRegistryName(new ResourceLocation("minecraft",
      "net/messages/" + this._toClassNameLower()));
  }

  public int getNetId()
  {
    return this._toClassNameLower().hashCode();
  }

  private String _toClassNameLower()
  {
    return this.getClass().getSimpleName().toLowerCase();
  }
}
