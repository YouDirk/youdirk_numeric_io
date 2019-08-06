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
import net.minecraft.item.ItemBlock;
import net.minecraft.item.Item;
import net.minecraft.item.ItemStack;
import net.minecraft.item.ItemGroup;
import net.minecraft.item.EnumRarity;
import net.minecraft.util.text.TextComponentTranslation;
import net.minecraft.util.text.ITextComponent;
import net.minecraft.world.World;
import net.minecraft.client.util.ITooltipFlag;

// Non Minecraft/Forge
import java.util.List;


/**
 * An abstract <code>ItemBlock</code> which implements the non
 * number-system specific, <b>common</b> mechanics.
 */
public abstract class ItemBlockNumericIO extends ItemBlock
{
  private static final int _MAX_STACKSIZE = 8;

  private static final Item.Properties _BUILDER = new Item.Properties()
    .group(ItemGroup.REDSTONE)
    .defaultMaxDamage(0)
    .maxStackSize(_MAX_STACKSIZE)
    .rarity(EnumRarity.UNCOMMON);

  private final TextComponentTranslation _DISPLAY_NAME;

  protected boolean clientConnectedVanilla = false;

  protected
  ItemBlockNumericIO(BlockNumericIO block, String displayName)
  {
    super(block, ItemBlockNumericIO._BUILDER);

    this.setRegistryName(block.getRegistryName());

    this._DISPLAY_NAME = new TextComponentTranslation(displayName);
  }

  @Override
  public ITextComponent getDisplayName(ItemStack stack)
  {
    return this._DISPLAY_NAME;
  }

  public void setClientConnectedVanilla(boolean value)
  {
    this.clientConnectedVanilla = value;
  }
  public boolean getClientConnectedVanilla(boolean localIsClient)
  {
    return localIsClient && this.clientConnectedVanilla;
  }

  public boolean isEnabled(boolean localIsClient)
  {
    return !this.getClientConnectedVanilla(localIsClient);
  }

  @Override
  public void addInformation(ItemStack stack, World world,
    List<ITextComponent> tooltip, ITooltipFlag flag)
  {
    net.dj_l.youdirk_numeric_io.client.ItemBlockNumericIOClient
      .addInformation(this, stack, world, tooltip, flag);
  }
}
