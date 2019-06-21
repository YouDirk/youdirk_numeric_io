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

// Gameplay
import net.minecraft.util.math.BlockPos;
import net.minecraft.util.SoundEvent;
import net.minecraft.util.SoundCategory;

// Network
import net.minecraft.network.PacketBuffer;
import net.minecraftforge.fml.network.NetworkEvent;
import net.minecraft.entity.player.EntityPlayerMP;

// Non Minecraft/Forge
import java.util.function.Supplier;


/**
 * TODO: Just a TestMessage for networking.  Remove this class it if
 * tests are finished!
 */
public class NetMessageTestSound extends NetMessage<NetMessageTestSound>
{
  public final BlockPos pos;
  public final SoundEvent sound;
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

  public NetMessageTestSound(BlockPos pos, SoundEvent sound,
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
    Log.ger.debug("TODO encode() ********************************");
  }

  @Override
  protected NetMessageTestSound decode(PacketBuffer buf)
  {
    Log.ger.debug("TODO decode() ********************************");

    return new NetMessageTestSound();
  }

  @Override
  protected void onReceive(Supplier<NetworkEvent.Context> ctx)
  {
    Log.ger.debug("TODO onReceive() ********************************");

    NetworkEvent.Context c = ctx.get();
    c.enqueueWork(() -> {
        EntityPlayerMP sender = c.getSender();

        Log.ger.debug("TODO onReceive() Dooo the woooork !!! uga uga uga");
      });

    c.setPacketHandled(true);
  }
}
