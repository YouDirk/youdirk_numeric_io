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
import net.minecraftforge.fml.network.NetworkEvent;

// Non Minecraft/Forge
import java.util.function.Supplier;
import java.util.function.BiConsumer;
import java.util.function.Function;


/**
 * Every NetMessage must implement these methods to serialize it and
 * add an event handler.
 */
public abstract class NetMessage<T extends NetMessage<T>>
{
  /**
   * A default constructor must be implemented to instanciate dummy
   * objects.  It can be empty.
   */
  public NetMessage() {}

  /**
   * Encode THIS to BUF
   */
  protected abstract void encode(PacketBuffer buf);

  /**
   * Decode BUF and return a new T.
   *
   * <b>Do not use <code>this</code>!  It´s a dummy instance.</b>
   */
  protected abstract T decode(PacketBuffer buf);

  /**
   * Enqueue the task, THIS holds the message.  Do not handle it
   * directly in this method!
   *
   * Example
   * <pre><code>
   * NetworkEvent.Context c = ctx.get();
   * c.enqueueWork(() -> {
   *   EntityPlayerMP sender = c.getSender();
   *   this.foo.bar();
   *   // more work todo here
   *   });
   * c.setPacketHandled(true);
   * </code></pre>
   */
  protected abstract void onReceive(Supplier<NetworkEvent.Context> ctx);

  /* *************************************************************  */

  public final BiConsumer<T,PacketBuffer> getEncoder()
  {
    return T::encode;
  }

  public final Function<PacketBuffer,T> getDecoder()
  {
    return (PacketBuffer buf) -> this.decode(buf);
  }

  public final BiConsumer<T,Supplier<NetworkEvent.Context>> getReceiver()
  {
    return T::onReceive;
  }
}
