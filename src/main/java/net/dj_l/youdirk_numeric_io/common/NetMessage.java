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

// Network
import net.minecraft.network.PacketBuffer;
import net.minecraftforge.fml.network.NetworkEvent;
import net.minecraft.entity.player.EntityPlayerMP;

// Non Minecraft/Forge
import javax.annotation.Nullable;
import java.util.function.Supplier;
import java.util.function.BiConsumer;
import java.util.function.Function;


/**
 * Every <code>NetMessage</code> must implement these abstract methods
 * to serialize it and add an event handler on receiving the message.
 *
 * <p>Make sure that your <code>NetMessage</code> class implements the
 * following <code>static</code> method:</p>
 *
 * <pre><code>
 *{@literal @}Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.MOD)
 * public class MyNetMessage extends NetMessage&lt;MyNetMessage&gt;
 * {
 *  {@literal @}SubscribeEvent
 *   public static void
 *   onRegister(final RegistryEvent.Register&lt;NetMessageBase&gt; event)
 *   {
 *     event.getRegistry().register(new MyNetMessage());
 *   }
 *
 *   . . .
 *
 * }
 * </code></pre>
 */
public abstract class NetMessage<T extends NetMessage<T>>
  extends NetMessageBase implements Runnable
{
  /**
   * <code>@Nullable</code> if we receive it on client.  Otherwise it
   * was set during <code>verifyDecoded()</code> and
   * <code>onReceive()</code>
   */
  protected @Nullable EntityPlayerMP sender = null;

  /**
   * <code>@Nullable</code>, was set during
   * <code>verifyDecoded()</code> and <code>onReceive()</code>
   */
  protected @Nullable NetworkEvent.Context ctx = null;

  /**
   * A default constructor without any parameter must be implemented
   * to instanciate dummy objects.  It can be empty, but
   * <code>super(String registryPath)</code> must be called.
   *
   * <p><b>The HashCode of the <code>registryPath</code> is used as
   * NetworkID for your message!</b> For this reason, do not rename it
   * to hold the network protocol compatible.</p>
   */
  protected NetMessage(String registryPath)
  {
    super(registryPath);
  }

  /**
   * Encode <code>this</code> to <code>buf</code>
   */
  protected abstract void encode(PacketBuffer buf);

  /**
   * Decode <code>buf</code> and return a new <code>T</code>.
   *
   * <b>Do not use <code>this</code>!  It´s a dummy instance.</b>
   */
  protected abstract T decode(PacketBuffer buf);

  /**
   * Verify if <code>this</code> has valid data.  Otherwise throws an
   * Exception.  All protected member variables are set.
   */
  protected abstract void verifyDecoded() throws NetPacketErrorException;

  /**
   * Called after succeeded <code>verifyDecoded()</code> and threaded
   * for workful CPU time.  All protected member variables are set.
   */
  protected abstract void onReceive();

  /* *****************************************************************
   * Optional overridings
   */

  @Override
  public String toString()
  {
    return "'NetId #" +this.getNetId()+ "'";
  }

  /* *****************************************************************
   * Final stuff
   */

  @Override
  public final void run()
  {
    try {
      this.verifyDecoded();
    } catch (NetPacketErrorException e) {
      Log.ger.warn("IGNORING network packet!", e);
      return;
    }

    this.onReceive();
  }

  protected final void
  onReceiveUnthreaded(Supplier<NetworkEvent.Context> ctx)
  {
    this.ctx = ctx.get();

    this.sender = this.ctx.getSender();

    this.ctx.enqueueWork(this);
    this.ctx.setPacketHandled(true);
  }

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
    return T::onReceiveUnthreaded;
  }
}
