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

// Gameplay
import net.minecraft.util.ResourceLocation;
import net.minecraft.block.Block;
import net.minecraft.item.Item;
import net.minecraftforge.registries.IForgeRegistry;

// Non Minecraft/Forge
import javax.annotation.Nullable;


/**
 * A place where all sub-classes of <code>ItemBlockNumericIO</code>
 * are collected for registering these during
 * <code>RegistryEvent.Register&lt;Item&gt;</code>.
 */
public class ItemBlockNumericIORegistry
  extends YoudirkNumericIORegistry<ItemBlockNumericIORegistry.Entry>
{
  private static final ResourceLocation
  _REGISTRY_NAME = new ResourceLocation(Props.MODID, "item_blocks");

  /* *************************************************************  */

  protected static class Entry
      extends YoudirkNumericIORegistryEntry<Entry> {
    protected final ItemBlockNumericIO ITEM;
    protected Entry(ItemBlockNumericIO item) {
      super(ItemBlockNumericIORegistry.Entry.class);
      this.setRegistryName(item.getRegistryName());

      this.ITEM = item;
    }
  }

  /* *************************************************************  */

  public ItemBlockNumericIORegistry()
  {
    // If we list the ItemBlocks, they should be alphabetic ordered
    super(ItemBlockNumericIORegistry.Entry.class,
          ItemBlockNumericIORegistry._REGISTRY_NAME,
          IterationOrderEnum.KEY_ORDER);
    ItemBlockNumericIORegistry._INSTANCE = this;
  }

  private static @Nullable ItemBlockNumericIORegistry _INSTANCE = null;
  public static @Nullable ItemBlockNumericIORegistry get()
  {
    return ItemBlockNumericIORegistry._INSTANCE;
  }

  public void
  registerOppositeBlocks(IForgeRegistry<Block> oppositeRegistry)
  {
    for (Entry itemEntry: this) {
      Block block = itemEntry.ITEM.getBlock();
      oppositeRegistry.register(block);
    }
  }

  public void
  registerOppositeItems(IForgeRegistry<Item> oppositeRegistry)
  {
    for (Entry itemEntry: this) {
      oppositeRegistry.register(itemEntry.ITEM);
    }
  }
}
