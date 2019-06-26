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

// Network
import net.minecraft.network.PacketBuffer;

// Gameplay
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.math.BlockPos;
import net.minecraft.util.SoundEvent;
import net.minecraft.util.SoundCategory;


/**
 * TODO: Just a TestMessage for networking.  Remove this class it if
 * tests are finished!
 */
public class NetMessageTestSound extends NetMessage<NetMessageTestSound>
{
  public final BlockPos pos;

  // May not exist on dedicated server
  public final ResourceLocation sound;

  public final SoundCategory category;
  public final float volume;
  public final float pitch;

  /**
   * A default constructor must be implemented to instanciate dummy
   * objects.  It can be empty.
   */
  public NetMessageTestSound()
  {
    this.pos = null;
    this.sound = null;
    this.category = null;
    this.volume = 0.0f;
    this.pitch = 0.0f;
  }

  public NetMessageTestSound(BlockPos pos, ResourceLocation sound,
    SoundCategory category, float volume, float pitch)
  {
    this.pos = pos;
    this.sound = sound;
    this.category = category;
    this.volume = volume;
    this.pitch = pitch;
  }


  @Override
  protected void encode(PacketBuffer buf)
  {
    buf.writeBlockPos(this.pos)
      .writeResourceLocation(this.sound)
      .writeString(this.category.toString())
      .writeFloat(this.volume)
      .writeFloat(this.pitch);
  }

  @Override
  protected NetMessageTestSound decode(PacketBuffer buf)
  {
    // THIS is a dummy instance

    return new NetMessageTestSound(
      buf.readBlockPos(),
      buf.readResourceLocation(),
      SoundCategory.valueOf(buf.readString(Net.STRLEN)),
      buf.readFloat(),
      buf.readFloat());
  }

  @Override
  protected void verifyDecoded() throws NetPacketErrorException
  {
    // TODO
    if (this.pos == null)
      throw new NetPacketErrorException("TODO");
  }

  @Override
  protected void onReceive()
  {
    // TODO Fire OwnSoundEvent
    Log.ger.debug("uga uga uga {}", this);
  }

  @Override
  public String toString()
  {
    String senderName = null;
    if (sender != null) {
      senderName = sender.getDisplayName().getString();
    }

    return "TestSound: " +this.pos+ ", '" + this.sound+ "', "
      +this.category+ ", volume=" +this.volume+ ", " +this.pitch
      + (senderName == null? "": "(sender: " +senderName+ ")");
  }
}
